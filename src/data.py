import pandas as pd

# Loading the data from a excel file
df_og = pd.read_excel(r'C:\Users\simplon\Ecole_IA\data_immo\data\Les_donnees.xlsx')
df = df_og.copy()

# Renaming the columns to fit the Model
df = df.rename(columns={
                "Date mutation": "DateMutation",
                "Valeur fonciere": "ValeurFonciere",
                "No voie": "NumVoie",
                "B/T/Q": "BTQ",
                "Type de voie": "TypeVoie",
                "Code voie": "CodeVoie",
                "Code postal": "CodePostal",
                "Commune": "NomCommune",
                "Code commune": "CodeCommune",
                "Prefixe de section": "PrefixeSection",
                "No plan": "NumPlan",
                "No volume": "NumVolume",
                "Nombre de lots": "NbLots",
                "Type local": "TypeLocal",
                "Surface reelle bati": "SurfaceBatie",
                "Surface terrain": "SurfaceTerrain",
                "Nombre pieces principales": "NbPieces"})

# Creating the Commune, Voie, and AdressLogement table
commune = df[['CodeCommune', 'NomCommune', 'CodePostal']].drop_duplicates()
voie = df[['CodeVoie', 'TypeVoie', 'Voie']].drop_duplicates()
adresse_logement = df[['NumVoie', 'BTQ', 'CodeVoie', 'CodeCommune']].drop_duplicates()

# Adding an index to the table that will be merged to get the dependencies
adresse_logement.insert(0, 'IdAdresse', 'a_' + adresse_logement.index.astype(str))
df = pd.merge(df, adresse_logement, on = adresse_logement.columns.to_list()[1:])

# Same thing with Logement and IdLogement
logement = df[['ValeurFonciere', 'TypeLocal', 'SurfaceBatie', 'SurfaceTerrain', 'NbPieces']].drop_duplicates()
logement.insert(0, 'IdLogement', 'l_' + logement.index.astype(str))
df = pd.merge(df, logement, on = logement.columns.to_list()[1:])

# Thirdly, on Mutation and IdMutation
mutation = df[['DateMutation']].drop_duplicates()
mutation.insert(0, 'IdMutation', 'm_' + mutation.index.astype(str))
df = pd.merge(df, mutation, on = mutation.columns.to_list()[1:])

# Creating association tables MutationAssoc and AdressAssoc
mutation_assoc = df[['IdLogement', 'IdMutation']].drop_duplicates()
adresse_assoc = df[['IdLogement', 'IdAdresse']].drop_duplicates()

# Export all into csv files for sql importation
voie.to_csv('../data/voie.csv', index = False)
commune.to_csv('../data/commune.csv', index = False)    
adresse_logement.to_csv('../data/adresse_logement.csv', index = False)
logement.to_csv('../data/logement.csv', index = False)
mutation.to_csv('../data/mutations.csv', index = False)
mutation_assoc.to_csv('../data/mutation_assoc.csv', index = False)
adresse_assoc.to_csv('../data/adresse_assoc.csv', index = False)