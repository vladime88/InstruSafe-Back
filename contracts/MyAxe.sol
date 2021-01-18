// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <=0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Un contrat de passeport instruments
/// @author Vladimir
/// @notice Ce contrat permet d'associer des guitares à des utilisateurs

contract MyAxe is ERC721, Ownable {
    using Counters for Counters.Counter; // Utilisation du contract Counter d'openzeppelin importait en ligne 6
    Counters.Counter private _tokenIds; // Utilisation de la fonction Counter pour associer un _tokenIds

    address payable private _superAdmin; // Adresse de la personne qui déploie

    /// @notice Name and symbol of the non fungible token, as defined in ERC721.
    constructor(address payable superAdmin) public ERC721("InstruSafe", "ISF") {
        _superAdmin = superAdmin;
    }

    enum Types {piano, guitar, trumpet} // Enumération
    /// enum Profil {professionel, particulier} // Enumération

    event MemberCreated(address indexed _address); // Event pour la créaction d'un membre
    event InstrumentToken(address indexed _address); // Event pour que soit créé un instrument

    struct Member {
        // Structure membres
        string name; // Nom du membre
        string tel; // Numéro de téléphone du membre
        bool isMember; // False par défaut, true si la pérsonne est déjà enregistré
        // Profil profil; // enum de porffessionel ou particulier
    }

    struct Instrument {
        // Structure instrument
        string brand; // marque de l'instrument
        string year; // année de production
        string ref; // référence de l'instrument
        bool authenticate; // Si il est authentifié ou non, false par defaut
        Types types; // Enumération de piano, guitare...
    }

    uint256 public instrumentsCount; // Variable de statut pour compter le nombre d'instruments

    /// @dev Mapping de la struct Instrument
    mapping(uint256 => Instrument) private _instrument;

    /// @dev Mapping de la struct Member
    mapping(address => Member) public member;

    // This modifer, vérifie si c'est le super admin
    modifier isSuperAdmin() {
        require(msg.sender == _superAdmin, "Vous n'avez pas le droit d'utiliser cette fonction");
        _;
    }

    // This modifer, vérifie si le membre est déjà enregistré
    modifier onlyMember() {
        require(member[msg.sender].isMember == true, "Vous n'etes pas membre");
        _;
    }

    // This modifer, vérifie si le membre n'est pas déjà enregistré
    modifier onlyNotMember() {
        require(member[msg.sender].isMember == false, "Vous etes deja membre");
        _;
    }

    /// This modifer, vérifie si le membre est déjà enregistré et son instrument authentifié
    /// modifier Approve() {
    /// require(_instrument[msg.sender].authenticate == true, "Votre instrument n'est pas authentifié");
    ///     _;}

    // This modifer, vérifie si l'instrument éxiste ou pas
    modifier instrumentIdCheck(uint256 instrumentId) {
        require(instrumentId < instrumentsCount, "L instrument n existe pas");
        _;
    }

    /// @dev Permet de créer un nouveau membre en vérifiant qu'il n'est pas déjà membre
    /// @param _name set le nom du membre dans la struct Member
    /// @param _tel set le numéro de téléphone dans la struct Member
    function createMember(string memory _name, string memory _tel) public onlyNotMember() {
        member[msg.sender] = Member({name: _name, tel: _tel, isMember: true});
        emit MemberCreated(msg.sender); /// emit de l'event MemberCreated
    }

    /// @dev Permet de récuperer les infos
    function getMember(address _addr) public view returns (Member memory) {
        return member[_addr];
    }

    /// @dev Crée un instrument et lui associe un token ERC721
    /// @param _member du membre à qui attibuer l'instrument/token
    /// @param _brand la marque de l'instrument
    /// @param _year annee de production de l'instrument
    /// @param _ref la refernce du modele de l'instrument
    /// @param _authenticate si l'instrument a un certificat d'authentification ou non
    /// @param types_ le type d'instrument de l'énunération
    /// @return le numéro de token

    function instrumentToken(
        address _member,
        string memory _brand,
        string memory _year,
        string memory _ref,
        bool _authenticate,
        Types types_
    ) public onlyMember() returns (uint256) {
        instrumentsCount++;
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(_member, newTokenId);
        _instrument[newTokenId] = Instrument({
            brand: _brand,
            year: _year,
            ref: _ref,
            authenticate: _authenticate,
            types: types_
        });
        emit InstrumentToken(msg.sender); /// emit de l'event InstrumentToken
        return newTokenId;
    }

    /// @dev Permet de retrouver un instrument en fonction de son numéro de token
    /// @param tokenId retrouver un instrument via son numéro de token
    function getInstrumentById(uint256 tokenId) public view returns (Instrument memory) {
        require(_exists(tokenId), "GTG: Instrument query for no nexistent token");
        return _instrument[tokenId];
    }
}
