import '../styles/globals.css'
import Link from 'next/link'

function Marketplace({ Component, pageProps }) {
  return (
    <div>
      <nav className="border-b p-6">
        <p className="text-4xl font-bold">Digiverse Marketplace</p>
        <div className="flex mt-4">
          <Link href="/">
            <a className="mr-4 text-blue-500">
              Accueil
            </a>
          </Link>
          <Link href="/create-item">
            <a className="mr-6 text-blue-500">
              Créer un NFT
            </a>
          </Link>
          <Link href="/my-assets">
            <a className="mr-6 text-blue-500">
              Mes NFTs
            </a>
          </Link>
          <Link href="/creator-dashboard">
            <a className="mr-6 text-blue-500">
              Dashboard
            </a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
  )
}

export default Marketplace