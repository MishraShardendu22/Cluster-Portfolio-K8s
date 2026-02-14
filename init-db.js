// MongoDB initialization script
// Run this inside the MongoDB pod to create the initial user document

db = db.getSiblingDB('personalwebsite');

// Check if user already exists
const existingUser = db.users.findOne();

if (!existingUser) {
    print("Creating initial user document...");
    
    db.users.insertOne({
        _id: ObjectId(),
        name: "Your Name",
        email: "your@email.com",
        skills: [],
        projects: [],
        experiences: [],
        certifications: [],
        volunteerExperiences: [],
        createdAt: new Date(),
        updatedAt: new Date()
    });
    
    print("User document created successfully!");
} else {
    print("User document already exists.");
}

print("Database initialized!");
