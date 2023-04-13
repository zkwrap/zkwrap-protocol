import { createContext, useContext, useState } from "react";

const ZkContext = createContext();


export const ZkContextProvider = ({children}) => {
        const [darkTheme, setDarkTheme] = useState(false)

        const changeTheme = (status) => {
            setDarkTheme(status)
        }

    return (
        <ZkContext.Provider value={{ 
            changeTheme,
            darkTheme
         }}>
            {children}
        </ZkContext.Provider>
    )
}


export const useDarkTheme = () => useContext(ZkContext)