import pandas as pd
import os

os.chdir('..')
FILE_PATH = os.getcwd() + '\data\RAW\\'
FILE_NAME = 'Les_donnees.xlsx'
#FILE_NAME = 'valeursfoncieres-2020.txt'
EXPORT_PATH = 'data/CURATED/'

# Loading the data from a excel file
if FILE_NAME.split('.')[1] == 'xlsx':
    df_og = pd.read_excel(fr'{FILE_PATH}{FILE_NAME}')
else:
    df_og = pd.read_csv(fr'{FILE_PATH}{FILE_NAME}', sep = '|')

df = df_og.copy()

# Renaming the columns to fit the Model
df = df.rename(columns={
                "Date mutation": "DateMutation",
                "Valeur fonciere": "ValeurFonciere",
                "Nature mutation": "TypeMutation",
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

# Creating the Commune and AdresseLogement table
commune = df[['CodeCommune', 'NomCommune', 'CodePostal']].drop_duplicates().reset_index(drop = True)

# Formating CodePostal into XXXXX format
commune['CodePostal'] = commune['CodePostal'].astype(str)
code = commune['CodePostal'].copy()
code = code.str[:-2]
code = pd.concat(['0' + code[code.str.len() == 4], code[code.str.len() == 5]])
commune['CodePostal'] = code

# Adding an index to the table that will be merged to get the dependencies
voie = df[['TypeVoie', 'Voie']].drop_duplicates().reset_index(drop = True)
voie.insert(0, 'IdVoie', voie.index)
df = pd.merge(df, voie, how = 'outer', on = voie.columns.to_list()[1:])

# Doing the same with AdresseLogement table
adresse_logement = df[['NumVoie', 'BTQ', 'IdVoie', 'CodeCommune']].drop_duplicates().reset_index(drop = True)
adresse_logement.insert(0, 'IdAdresse', adresse_logement.index)
df = pd.merge(df, adresse_logement, how = 'outer', on = adresse_logement.columns.to_list()[1:])

# Doing the same with Logement table
logement = df[['TypeLocal', 'SurfaceBatie', 'SurfaceTerrain', 'NbPieces', 'IdAdresse']].drop_duplicates().reset_index(drop = True)
logement.insert(0, 'IdLogement', logement.index)
df = pd.merge(df, logement, on = logement.columns.to_list()[1:])

# Thirdly, on Mutation and IdMutation
mutation = df[['DateMutation', 'ValeurFonciere', 'TypeMutation', 'IdLogement']].drop_duplicates().reset_index(drop = True)
mutation.insert(0, 'IdMutation', df.index)
df = pd.merge(df, mutation['IdMutation'], how = 'outer', left_on = df.index, right_on = 'IdMutation')

# Export all into csv files for sql importation
voie.to_csv(EXPORT_PATH + 'voie.csv', index = False)
commune.to_csv(EXPORT_PATH + 'commune.csv', index = False)    
adresse_logement.to_csv(EXPORT_PATH + 'adresse_logement.csv', index = False)
logement.to_csv(EXPORT_PATH + 'logement.csv', index = False)
mutation.to_csv(EXPORT_PATH + 'mutation.csv', index = False)