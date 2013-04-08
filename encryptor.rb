require 'digest'
class Encryptor

 def supported_characters
   (' '..'z').to_a
 end

 def cipher(rotation, encrypting)
   characters = supported_characters
   rotated_characters = characters.rotate(rotation)
   code = Hash[characters.zip(rotated_characters)]
   return encrypting ? code : code.invert
 end

 def encrypt(string, rotation = 13)
   letters = string.split("")
   result = letters.collect do |letter|
     encrypt_letter(letter, rotation, true)
   end
   result.join
 end
 def decrypt(string, rotation = 13)
   letters = string.split("")
   result = letters.collect do |letter|
     encrypt_letter(letter, rotation, false)
   end
   result.join
 end
 def encrypt_file(filename, rotation = 13)
   input = File.open(filename, "r")
   text = input.readlines
   input.close
   output = File.open(filename + ".encrypted", "w")
   text.each do |line|
     output.write(encrypt(line.strip, rotation) + "\n")
   end
  output.close
 end
 def decrypt_file(filename, rotation = 13)
   input = File.open(filename, "r")
   text = input.readlines
   input.close
   output = File.open(filename + ".decrypted", "w")
   text.each do |line|
     output.write(decrypt(line.strip, rotation) + "\n")
   end
  output.close
 end
 def crack(string)
  supported_characters.to_a.count.times do |attempt|
  puts decrypt(string, attempt) + " (ROT-" + attempt.to_s + ")."
  end
 end
 def betterencrypt(string)
      letters = string.split("")
      rotation = 3;
      newresult = Array.new
   letters.collect do |letter|
     encrypted_char = encrypt_letter(letter, rotation, true)
     if rotation == 3 or rotation == 5
       rotation += 2
     else
       rotation = 3
     end
     encrypted_char
   end.join("")
 end
 def betterdecrypt(string)
      letters = string.split("")
      rotation = 3;
      newresult = Array.new
   result = letters.map do |letter|
     newresult << encrypt_letter(letter, rotation, false)
     if rotation == 3 or rotation == 5
       rotation += 2
     else
       rotation = 3
     end
   end
   newresult.join
 end

private
   def encrypt_letter(letter, rotation = 13, encrypting)
    cipher_for_rotation = cipher(rotation, encrypting)
    cipher_for_rotation[letter]
    end

end

def cyan(text)
  text = "\033[36m" + text + "\033[0m"
end

def magenta(text)
  text = "\033[35m" + text + "\033[0m"
end

def encmode()
  puts cyan("Now you are in ENCRYPT mode.")
  e = Encryptor.new
  input = gets
  while input.chomp != "\\DECRYPT" and input.chomp != "\\EXIT"
    puts cyan(e.betterencrypt(input))
    input = gets
  end

  if input.chomp == "\\DECRYPT"
    decmode()
  else
    $flag = 1
  end
end

def decmode()
  puts magenta("Now you are in DECRYPT mode.")
  d = Encryptor.new
  input = gets
  while input.chomp != "\\ENCRYPT" and input.chomp != "\\EXIT"
    puts magenta(d.betterdecrypt(input))
    input = gets
  end

  if input.chomp == "\\ENCRYPT"
    encmode()
  else
    $flag = 1
  end
end


print "Password for encryptor: "
system("stty -echo")
password = gets
print "\n"
system("stty echo")
# e = Encryptor.new
# if password == e.encrypt('"n%%)!$q"')

md5 = Digest::MD5.new()
if md5.hexdigest(password.chomp) == "5f4dcc3b5aa765d61d8327deb882cf99"
system("clear");
puts  cyan("Welcome to the encryptor program.")
puts "Type \\ENCRYPT or \\DECRYPT to choose mode, or \\EXIT to do you know what."
input = ""
$flag = 0
while $flag != 1
input = gets
case input.chomp
when "\\ENCRYPT"
  encmode()
when "\\DECRYPT"
  decmode()
when "\\EXIT"
  $flag = 1
else
  puts "Please, select a mode."
end
end

else

puts "Exiting..."
end
