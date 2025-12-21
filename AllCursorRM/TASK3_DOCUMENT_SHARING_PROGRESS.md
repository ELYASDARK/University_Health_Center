# TASK 3: Document Sharing Feature - Progress Report

## ✅ Implementation Status: IN PROGRESS (70% Complete)

This document tracks the progress of the Document Sharing feature implementation.

## 🎯 Completed Components (✅)

### 1. **Shared Document Model** ✅
- **File**: `lib/features/documents/domain/models/shared_document.dart`
- Complete data model with:
  - Document metadata (IDs, type, title, description, file info)
  - Timestamps (shared, expires, viewed)
  - Status flags (revoked, viewed, expired)
  - Helper methods (formatted size, file checks, status text/colors)
- Document types enum: Prescription, Lab Report, Medical Report, Scan, Other
- Constants for validation (max 10MB, allowed types: PDF, JPG, JPEG, PNG)

### 2. **Shared Documents Repository** ✅
- **File**: `lib/features/documents/data/repositories/shared_documents_repository.dart`
- Complete CRUD operations:
  - Get patient documents
  - Get doctor documents
  - Get appointment documents
  - Share document (upload + save metadata)
  - Mark as viewed
  - Revoke access
  - Delete document
  - Get unviewed count
  - Stream documents (real-time)

### 3. **Use Cases** ✅
- **Share**: `lib/features/documents/domain/usecases/share_document_with_patient.dart`
  - Validates inputs
  - Shares document with patient
  - Sends notification

- **Get**: `lib/features/documents/domain/usecases/get_shared_documents.dart`
  - Get documents for patient
  - Get documents by doctor
  - Get documents for appointment
  - Get unviewed count

- **Revoke**: `lib/features/documents/domain/usecases/revoke_document_access.dart`
  - Revoke access to document
  - Delete document completely

### 4. **UI Components** ✅
- **Shared Document Card**: `lib/features/documents/presentation/widgets/shared_document_card.dart`
  - Document type icon with color coding
  - Status badge (New, Viewed, Revoked, Expired)
  - File info (type, size)
  - Shared date
  - Doctor/Patient name
  - Revoke action menu (for doctors)

### 5. **Notification Service Update** ✅
- **Modified**: `lib/core/services/notification_service.dart`
- Added `sendDocumentSharedNotification` method
- Sends local notification and saves to Firestore

### 6. **Package Dependencies** ✅
- Added to `pubspec.yaml`:
  - `flutter_pdfview: ^1.3.3` - PDF viewing
  - `photo_view: ^0.15.0` - Image viewing

## 🔨 Remaining Components (To Be Implemented)

### 7. **Patient Shared Documents Page** ⏳
- **File**: `lib/features/documents/presentation/pages/shared_documents_page.dart`
- List of all documents shared with patient
- Filter by document type
- View document on tap
- Download documents
- Mark as viewed automatically

### 8. **Doctor Upload Document Page** ⏳
- **File**: `lib/features/documents/presentation/pages/doctor_upload_document_page.dart`
- File picker for document selection
- Document type selection
- Title and description fields
- Patient selection (from appointment)
- Expiration date setting (optional)
- Upload progress indicator

### 9. **Document Viewer Pages** ⏳
- **PDF Viewer**: For viewing PDF documents
- **Image Viewer**: For viewing image documents
- Download button
- Share functionality
- Mark as viewed on open

### 10. **Profile Integration** ⏳
- **Modify**: `lib/features/profile/presentation/screens/profile_screen.dart`
- Add "Shared Documents" card for patients
- Show unviewed documents badge
- Navigate to shared documents page

### 11. **Appointment Details Integration** ⏳
- **Modify**: `lib/features/appointments/presentation/pages/appointment_details_page.dart`
- Add "View Documents" button (for patients)
- Add "Share Document" button (for doctors)
- Show document count
- Navigate to appointment documents

### 12. **Navigation Setup** ⏳
- **Modify**: `lib/main.dart`
- Add `/shared-documents` route
- Add `/doctor-upload-document` route
- Import new pages

## 📊 Architecture

### Clean Architecture Layers (Implemented)

```
Domain Layer (Business Logic)
├── SharedDocument (model) ✅
├── SharedDocumentType (enum) ✅
├── ShareDocumentWithPatient (use case) ✅
├── GetSharedDocuments (use case) ✅
└── RevokeDocumentAccess (use case) ✅

Data Layer
└── SharedDocumentsRepository ✅

Presentation Layer (Partial)
└── SharedDocumentCard (widget) ✅
```

## 📊 Firestore Schema

### Collection: `sharedDocuments`

```javascript
{
  documentId: {
    doctorId: "string",              // Doctor who shared
    patientId: "string",             // Patient recipient
    appointmentId: "string",         // Related appointment
    documentType: "string",          // prescription, labReport, etc.
    title: "string",                 // Document title
    description: "string",           // Description
    fileUrl: "string",               // Firebase Storage URL
    fileName: "string",              // Original file name
    fileSize: 1024000,               // Size in bytes
    sharedAt: Timestamp,             // When shared
    expiresAt: Timestamp?,           // Optional expiration
    isRevoked: false,                // Access revoked?
    viewedAt: Timestamp?,            // When patient viewed it
    doctorName: "string",            // For display
    patientName: "string"            // For display
  }
}
```

### Indexes Required
```javascript
Collection: sharedDocuments
- patientId (ascending) + isRevoked (ascending) + sharedAt (descending)
- doctorId (ascending) + sharedAt (descending)
- appointmentId (ascending) + isRevoked (ascending) + sharedAt (descending)
```

## 📁 Firebase Storage Structure

```
/shared-documents/
  /{appointmentId}/
    /prescription_1234567890.pdf
    /lab_report_1234567891.jpg
    /scan_1234567892.png
```

## 🔐 Security Recommendations

### Firestore Security Rules

```javascript
match /sharedDocuments/{documentId} {
  // Patients can read their own documents
  allow read: if request.auth != null && 
                 request.auth.uid == resource.data.patientId &&
                 resource.data.isRevoked == false;
  
  // Doctors can read documents they shared
  allow read: if request.auth != null && 
                 request.auth.uid == resource.data.doctorId;
  
  // Only doctors can create documents
  allow create: if request.auth != null && 
                   request.resource.data.doctorId == request.auth.uid &&
                   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'doctor';
  
  // Only doctors can revoke their own documents
  allow update: if request.auth != null && 
                   request.auth.uid == resource.data.doctorId &&
                   request.resource.data.keys().hasOnly(['isRevoked', 'viewedAt']);
  
  // Only doctors can delete their own documents
  allow delete: if request.auth != null && 
                   request.auth.uid == resource.data.doctorId;
}
```

### Firebase Storage Security Rules

```javascript
match /shared-documents/{appointmentId}/{fileName} {
  // Allow read if user is the patient or doctor involved
  allow read: if request.auth != null && (
    exists(/databases/$(database)/documents/sharedDocuments/$(resource.name)) &&
    (get(/databases/$(database)/documents/sharedDocuments/$(resource.name)).data.patientId == request.auth.uid ||
     get(/databases/$(database)/documents/sharedDocuments/$(resource.name)).data.doctorId == request.auth.uid)
  );
  
  // Only doctors can upload
  allow write: if request.auth != null && 
                  get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'doctor';
}
```

## 🎨 UI Design Specifications

### Shared Documents List (Patient View)
- **Layout**: List view with cards
- **Sorting**: Most recent first
- **Filtering**: By document type
- **Status Indicators**:
  - 🟢 Green badge: "New" (unviewed)
  - 🔵 Blue badge: "Viewed"
  - 🔴 Red badge: "Revoked"
  - ⚫ Grey badge: "Expired"
- **Color Coding by Type**:
  - 💜 Purple: Prescription
  - 🔵 Blue: Lab Report
  - 🟠 Orange: Medical Report
  - 🟢 Green: Scan/X-Ray
  - ⚫ Grey: Other

### Doctor Upload Form
- **Fields**:
  - Document Type (dropdown)
  - Title (text input)
  - Description (multiline text)
  - File picker button
  - Expiration date (date picker, optional)
- **Validation**:
  - Max file size: 10 MB
  - Allowed types: PDF, JPG, JPEG, PNG
  - Required fields: Type, Title, File
- **Progress**: Upload progress bar

### Document Viewer
- **PDF**: Full-screen PDF viewer with zoom/scroll
- **Images**: Zoomable image viewer
- **Actions**:
  - Download button
  - Share button (system share sheet)
  - Back button
- **Auto-mark**: Automatically mark as viewed when opened

## 📱 User Flows

### Doctor Shares Document
1. Doctor opens appointment details
2. Taps "Share Document" button
3. Selects file from device
4. Chooses document type
5. Enters title and description
6. (Optional) Sets expiration date
7. Taps "Share"
8. Progress indicator shows upload
9. Success message displayed
10. Patient receives notification

### Patient Views Document
1. Patient receives notification
2. Opens app → Shared Documents
3. Sees new document with green "New" badge
4. Taps document card
5. Document viewer opens
6. (PDF viewer or Image viewer)
7. Document marked as viewed
8. Badge changes to blue "Viewed"
9. Can download or share

### Doctor Revokes Access
1. Doctor opens shared documents list
2. Taps menu icon on document
3. Selects "Revoke Access"
4. Confirms action
5. Document status set to revoked
6. Patient can no longer view it

## 🧪 Testing Checklist

### Completed Tests
- [x] Shared document model creation
- [x] Repository CRUD operations
- [x] Use case validation
- [x] Document card rendering
- [x] Status badge display
- [x] Color coding by type
- [x] Date formatting

### Pending Tests
- [ ] Share document flow (doctor)
- [ ] View document flow (patient)
- [ ] Download document
- [ ] Revoke access
- [ ] Mark as viewed
- [ ] Document expiration
- [ ] File type validation
- [ ] File size validation
- [ ] Notification sending
- [ ] PDF viewing
- [ ] Image viewing
- [ ] Offline access

## 💡 Next Steps

### Immediate Tasks
1. Create patient shared documents page
2. Create doctor upload document page
3. Create PDF viewer page
4. Create image viewer page
5. Integrate with profile screen
6. Integrate with appointment details
7. Add navigation routes
8. Install dependencies (`flutter pub get`)
9. Test complete flow
10. Update security rules

### Future Enhancements
1. **Batch Upload**: Share multiple documents at once
2. **Document Templates**: Pre-filled forms for common documents
3. **Digital Signatures**: Doctor signatures on prescriptions
4. **Document History**: Track all versions of a document
5. **Search**: Search documents by title/description
6. **Tags**: Tag documents for better organization
7. **Export**: Export all documents as ZIP
8. **Print**: Print documents directly from app
9. **OCR**: Extract text from images
10. **Translation**: Translate document content

## 📚 API Reference

### SharedDocument

```dart
class SharedDocument {
  final String id;
  final String doctorId;
  final String patientId;
  final String appointmentId;
  final SharedDocumentType documentType;
  final String title;
  final String description;
  final String fileUrl;
  final String fileName;
  final int fileSize;
  final DateTime sharedAt;
  final DateTime? expiresAt;
  final bool isRevoked;
  final DateTime? viewedAt;
  
  String get formattedFileSize;
  String get fileExtension;
  bool get isPdf;
  bool get isImage;
  bool get hasBeenViewed;
  bool get isExpired;
  bool get isAccessible;
  String get statusText;
  String get statusColor;
}
```

### SharedDocumentsRepository

```dart
class SharedDocumentsRepository {
  Future<List<SharedDocument>> getPatientDocuments(String patientId);
  Future<List<SharedDocument>> getDoctorDocuments(String doctorId);
  Future<List<SharedDocument>> getAppointmentDocuments(String appointmentId);
  Future<SharedDocument?> getDocument(String documentId);
  Future<SharedDocument> shareDocument({...});
  Future<void> markAsViewed(String documentId);
  Future<void> revokeAccess(String documentId);
  Future<void> deleteDocument(String documentId);
  Future<int> getUnviewedDocumentsCount(String patientId);
  Stream<List<SharedDocument>> watchPatientDocuments(String patientId);
  Stream<List<SharedDocument>> watchDoctorDocuments(String doctorId);
}
```

## 🎉 Summary

**70% of the Document Sharing feature is complete!**

### What's Done:
✅ Complete data layer (models, repository)  
✅ Complete domain layer (use cases)  
✅ Notification integration  
✅ Document card widget  
✅ Package dependencies added  

### What Remains:
⏳ Patient documents page (list view)  
⏳ Doctor upload page (form)  
⏳ PDF/Image viewers  
⏳ Profile integration  
⏳ Appointment details integration  
⏳ Navigation setup  

### Time Estimate:
- Remaining UI pages: ~2 hours
- Integration work: ~1 hour
- Testing & refinement: ~1 hour
- **Total remaining: ~4 hours**

---

**Implementation Date**: December 19, 2025  
**Status**: ⏳ 70% Complete  
**Next Session**: Complete UI pages and integration

