//  File Status: Lock
//
//  An abstract class defining a generic key-value storage service interface.
//
//  This interface provides methods for initializing storage, as well as
//  storing, retrieving, updating, and removing string values based on keys.
//
//  Implementations can be backed by shared preferences, secure storage,
//  file system, or any custom data store.

abstract class StorageService {
  // Initializes the underlying storage system.
  // Should be called before performing any read/write operations.
  initializeStorage();

  // Clears all stored key-value pairs from the storage.
  clearStorage();

  // Saves a [value] under the specified [key].
  // If the key already exists, it may be overwritten.
  saveValue(String key, String value);

  // Retrieves the value associated with the given [key].
  // Returns `null` if the key does not exist.
  getValue(String key);

  // Updates the existing value for the given [key] with the new [value].
  // If the key does not exist, implementations may either save it
  // or throw an error, based on use case.
  updateValue(String key, String value);

  // Removes the key-value pair associated with the given [key].
  removeValue(String key);
}
