module Option
  
  def Option.placezero                              # create new key pair
    fstart  # call function
    system "gpg --gen-key"
    fend
  end
  
  def Option.placeone                               # list keys
    fstart
    puts "This option lists all public and secret/private keys."
    puts "Do you want to list public or secret key? (Type 'p' or 's')"
    keytype = gets.chomp
    
    if keytype == "p"
      system "gpg --list-keys"
    elsif keytype == "s"
      system "gpg --list-secret-keys"
    else
      puts "You did not choose public or secret."
    end
    fend
  end

  def Option.placetwo                               # import and export keys
    fstart
    puts "You can import keys from other people.  You can also export keys to give to people."
    puts "Do you want to import or export a key? (Type 'i' or 'e')"
    impex = gets.chomp
    if impex == "i"
        puts "Type the path and name of the key you are importing."
        impname = gets.chomp
        system "gpg --import " + impname
        print impname + " imported."
    elsif impex == "e"
      puts "This option exports the key to a text file."
      puts "Do you want to export a public or secret key? (Type 'p' or 's')"
      keytype = gets.chomp
      
      if keytype == "p"
        puts "Type the path and name of the key your are exporting."
        publicname = gets.chomp
        puts "Type the name you want to give the secret key file."
        keyname = gets.chomp
        system "gpg -a --export " + publicname + " > " + keyname + ".txt"  # -a is the same as --armor
        puts "Done."
      elsif keytype == "s"
        puts "Type the path and name of the key your are exporting."
        secretname = gets.chomp
        puts "Type the name you want to give the secret key file."
        keyname = gets.chomp
        system "gpg -a --export-secret-keys " + secretname + " > " + keyname + ".txt"
        puts "Done."
      else
        puts "You did not choose public or secret."
      end
    else
      puts "You did not choose import or export."
    end
    fend2
  end
  
  def Option.placethree                              # delete keys
    fstart
    puts "This option allows you to delete a key."
    puts "Do you want to delete a public or secret key? (Type 'p' or 's')"
    deletetype = gets.chomp
    if deletetype == "p"
      puts "Type the name of the actual key your are deleting."
      publicdelname = gets.chomp
      system "gpg --delete-key " + publicdelname
  
    elsif deletetype == "s"
      puts "Type the name of the actual key your are deleting."
      secretdelname = gets.chomp
      system "gpg --delete-secret-key " + secretdelname
  
    else
      puts "You did not choose public or secret."
    end
    fend2
  end
  
  def Option.placefour                               # fingerprint and sign a key
    fstart
    puts "Once a key is imported it should be validated or signed.  You do this"
    puts "by verifying the key's fingerprint.  Then sign the key to cerify\nit is a valid key."
    puts "\nDo you want to go ahead and do this? (Type 'y' or 'n')"
    signkey = gets.chomp
    if signkey == "y"
      system "clear" or system "cls"
      puts "Type the name of the key you want to fingerprint or sign."
      signname = gets.chomp
      system "clear" or system "cls"
      puts "You will be placed in the GPG menu.  Once there, type 'fpr' and press enter."
      puts "The key fingerprint will be displayed.  You can verify with the\nowner of the key that "\
             " the fingerprint is correct."
      puts "\nIf the fingerprint is correct, you can type 'sign' to validate the key."
      puts "If you have other keys from people that are friends with the owner of this key, you"\
           " can type 'check' and verify the key is valid."
      puts "When you are finished you can type 'quit' and press enter."
      puts "\nRead carefully then press Enter to continue."
      gets 
      system "gpg --edit-key " + signname
    elsif signkey == "n"
      # do nothing
    else
      puts "You did not choose yes or no."
    end
    fend2
  end
  
  def Option.placefive                               # trust a key
    fstart
    puts "When importing a key from another location, you may have to configure\nGPG to trust the key."
    puts "Otherwise, GPG may prompt you to trust the key each time you use\ndecryption."
    puts "\nDo you want to go ahead and trust a key now? (Type 'y' or 'n')"
    trustkey = gets.chomp
    if trustkey == "y"
      puts "Type the name of the key you want to trust."
      trustname = gets.chomp
      system "clear" or system "cls"
      puts "\nYou will be placed in the GPG menu.  Once there, type the word 'trust'\nand press enter."
      puts "Then select the level of trust you want to give the key."
      puts "When you are finished you can type 'quit' and press enter."
      puts "\nEnter to Continue"
      gets 
      system "gpg --edit-key " + trustname
    elsif trustkey == "n"
      # do nothing
    else
      puts "You did not choose yes or no."
    end
    fend2
  end
  
  def Option.placesix                             # quick encrypt
    fstart
    puts "Type the path and name of the file you want to encrypt."
    puts "Example:  /home/username/lexan.txt"
    quickfile = gets.chomp
    puts "Specify the name or recipient who shall be able to decrypt the file."
    quickrecipient = gets.chomp
    system "gpg --encrypt --recipient " + quickrecipient + " " + quickfile
    puts "\n " + quickfile + " encrypted."
    puts "\n\nPress Enter to continue."
    gets # waits for the user to press enter
  end
  
  def Option.placeseven                           # encrypt with name
    fstart
    puts "Type the path and name of the file you want to encrypt."
    puts "Example:  /home/username/lexan.txt"
    quickfile = gets.chomp
    puts "What do you want to name the encrypted file?  You can also specify\nthe directory you want it stored in."
    encryptname = gets.chomp
    puts "Type the key name or recipient who shall be able to decrypt the file."
    quickrecipient = gets.chomp
    system "clear" or system "cls"
    puts "Do you want to only allow the recipient to decrypt the file or\ndo you want to allow both you and the recipient to decrypt the file?"
    puts "(Type 'r' for recipient only or 'b' for both.)"
    whodecrypt = gets.chomp
    if whodecrypt == "r"
      system "gpg -r " + quickrecipient + " --output " + encryptname + " --encrypt " + quickfile
      puts "\n " + quickfile + " encrypted as" + encryptname + "."
    elsif whodecrypt == "b"
      system "clear" or system "cls"
      puts "Type your own public key name here."
      mykey = gets.chomp
      system "gpg -r " + quickrecipient + " --encrypt-to " + mykey + " --output " + encryptname + " --encrypt " + quickfile
      puts "\n " + quickfile + " encrypted as " + encryptname + "."
    else
      puts "You did not choose r or b."
    end
    fend2
  end
  
  def Option.placeeight                             # quick decrypt
    fstart
    puts "Type the path and name of the file you want to decrypt."
    puts "Example:  /home/username/lexan.pgp"
    quickfile = gets.chomp
    system "gpg " + quickfile
    puts "\n " + quickfile + " decrypted."
    puts "\n\nPress Enter to continue."
    gets # waits for the user to press enter
  end
  
  def Option.placenine                             # decrypt with name
    fstart
    puts "Type the path and name of the file you want to decrypt."
    puts "Example:  /home/username/lexan.gpg"
    quickfile = gets.chomp
    puts "What do you want to name the decrypted file?  You can also specify\nthe directory you want it stored in."
    decryptname = gets.chomp
    puts "Specify the key name or recipient who shall be able to decrypt the file."
    quickrecipient = gets.chomp
    system "gpg -r " + quickrecipient + " --output " + decryptname + " --decrypt " + quickfile
    puts "\n " + quickfile + " decrypted."
    puts "\n\nPress Enter to continue."
    gets # waits for the user to press enter
  end
  
  def Option.placeten                            # terminal decrypt
    fstart
    puts "This option will decrypt and display readable documents to the terminal."
    puts "Do you want to do this? (Type 'y' or 'n')"
    terminaldisplay = gets.chomp
    if terminaldisplay == "y"  
      puts "Type the path and name of the document file you want to decrypt."
      puts "Example:  /home/username/lexandoc.pgp"
      displayfile = gets.chomp
      system "gpg --decrypt " + displayfile
      puts "\n\nPress Enter to continue."
      gets # waits for the user to press enter
    elsif terminaldisplay == "n"
      # do nothing
    else
      # do nothing
    end
  end
  
  def Option.placeeleven                        # encrypt file for e-mail and web
    fstart
    puts "This option will encrypt a file to binary format so that the file\ncan be sent through e-mail or published on the web."
    puts "Do you want to do this? (Type 'y' or 'n')"
    terminaldisplay = gets.chomp
    if terminaldisplay == "y"  
      puts "Type the path and name of the file you want to export."
      binaryname = gets.chomp
      puts "Specify the key name or recipient who shall be able to decrypt the file."
      encrecipient = gets.chomp
      system "gpg -r " + encrecipient + " --armor --encrypt " + binaryname
      puts "\n\n" + binaryname + ".asc has been created."
      puts "Press Enter to continue."
      gets # waits for the user to press enter
    elsif terminaldisplay == "n"
      # do nothing
    else
      # do nothing
    end
    fend2
  end
  
  def Option.placetwelve                        # create or verify signature file
    fstart
    puts "GPG can create and verify detached signatures or .asc files."
    puts "A detatched signature allows your to verify if a file you've\ndownloaded is the one it's creator wants you to have."
    puts "This option allows you to create a signature for a file or\nverify a signature for a file."
    puts "Do you want to create or verify? (Type 'c' or 'v')"
    detsig = gets.chomp
    if detsig == "c"
      system "clear" or system "cls"
      puts "Type the path and name of the file you want to create a\nsignature for."
      puts "Example:  /home/username/lexan.tar.gz"
      create = gets.chomp
      system "gpg --armor --detach-sign " + create
      puts create + ".asc created."
    elsif detsig == "v"
      system "clear" or system "cls"
      puts "Type the path and name of the signature you want to verify.\nIt will end with .asc"
      puts "Example:  /home/username/lexan.asc"
      asc = gets.chomp
      puts "Type the path and name of the the file you want to match the signature to."
      puts "Example:  /home/username/lexan.tar.gz"
      sigfile = gets.chomp
      system "gpg --verify " + asc + " " + sigfile
    else
      puts "You did not choose create or verify."
    end
    fend2
  end
  
  def Option.placethirteen                       # generate a revocation key
    fstart
    puts "After creating a key you should create a revocation certificate."
    puts "You can use a revocation certificate when your key is lost or compromised."
    puts "This can be done by uploading the revocation certificate to a key server."
    puts "Do you want to create a revocation certificate? (Type 'y' or 'n')"
    revcert = gets.chomp
    if revcert == "y"
      system "clear" or system "cls"
      puts "Type the name of the key you want to make a revocation certificate for."
      certname = gets.chomp
      system "gpg --gen-revoke --armor --output=" + certname + "-RevCert.asc " + certname
      system "clear" or system "cls"
      puts certname + "-RevCert.asc created."
    elsif revcert == "n"
      # do nothing
    else
      puts "You did not choose yes or no."
    end
    fend2
  end

end
