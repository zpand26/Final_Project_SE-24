import pandas as pd


data_file = 'data.csv'
software_file = 'software.csv'

data = pd.read_csv(data_file)
software = pd.read_csv(software_file)


def clean_dataset(df, file_name):
    print(f"Cleaning dataset: {file_name}")

    #Remove duplicate rows
    initial_rows = df.shape[0]
    df = df.drop_duplicates()
    print(f"Removed {initial_rows - df.shape[0]} duplicate rows.")

    # Handle missing values
    df = df.dropna()

    #Correct data types
    for col in df.columns:
        if df[col].dtype == 'object':
            # Standardize strings
            df[col] = df[col].str.strip().str.lower()
        elif pd.api.types.is_numeric_dtype(df[col]):
            # change invalid numeric values to NaN and fill with 0
            df[col] = pd.to_numeric(df[col], errors='coerce').fillna(0)

    #Identify and remove invalid data
    numeric_cols = df.select_dtypes(include=['number']).columns
    for col in numeric_cols:
        invalid_rows = df[df[col] < 0].shape[0]
        df = df[df[col] >= 0]
        if invalid_rows > 0:
            print(f"Removed {invalid_rows} invalid rows in column {col} (negative values).")

    #Save cleaned dataset
    cleaned_file_name = f"cleaned_{file_name}"
    df.to_csv(cleaned_file_name, index=False)
    print(f"Saved cleaned dataset to {cleaned_file_name}\n")
    return df

cleaned_data = clean_dataset(data, data_file)
cleaned_software = clean_dataset(software, software_file)

print("Data cleaning complete!")
