ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.8.0
docker tag hyperledger/composer-playground:0.8.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ؊QY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���W�^}��W�^U��r�b6-Ӂ!K��u�lj����0b1���9&���6�r|��y���(�> �ѿZ�+� <pm��9W�M��=�6��4��2�LQ�ۚ�5�����ƿW�hr��cI�֔�(�ѵ��C��H/>Х�eڮ�e	@,�0+��o��A��٦ф��CJ泅|Y*%�Lz|�G �� ���ݤiPqQ�
�Y�tH����䪭)�`
e�A��<A �p��5qe�>O�bk&�7/+l�$�͆��t.B�sn���'��+�e״	V�a6a��#�FM	!��CF3ך�l�(e�aFbM[�6�(��P���e똋�m)k���>�䦥�0bk-�=��b(��/JCF-Drov{?F����Ia��]g���(�"�i�K��k!�y�i~$�@���b�	�T�6<mA��)m*���MT�aVG{	���$M�Gt�6����-���&�3�Tq'�M��K._�)K���{����W�E]~���	~���d��mC�{C��w��R�=X��"��v���F����q��Co��Q<��,} �;�d|�����w�l�f��&��Ӹ-������rn6*�<��P��y.�������T5#R���-[��~�(*��j6
����X�<*�wJI�����h������+r��2��Qg�!�?`#�X�qsޫ��х����q���d�-��ǎi�	b�᯴���#�8�8l�����g.��_��hg +/�7a&̄�^�m��A��9�5�Y��y0���?@ʹ�j�u��f�:.�Z6^{�X�֖]̣k� 	�[nô��*��)�pH�Dԙ0�y'�����"�N�r�4d���֘t��[�H^R��jA�f-` �U�"�]C|cr�8a&$�VC��}�뱰	�8�g�z��^B�ԴW��Ֆ��!�VZ��D�[�B!�۱@����2/Tѩ�����x4�z���5/��}c��Z؏Y���qa	}�b17|pp��O�����
8A������(�Y���A��z��j-�Łې]p��:�m�4�B`�C3ꗛ�O並�����
����*�B�r@������MX�A~�h�}��4���	�-D�-#��th ���a#FKױ%ϣ@�$9S5���A�ܕ�K��=�Ӑ���dB5L���F��`��]��@�E��<Rg�K�}l,����d潴�1�a�L{l��ܓ�@���g�a���͸����o6}F��� ��z�i�]R)�:�ѹ1胘��.���Z��+��]eWli.I�yWM��u��<�P����ԡ�NCS�$��Д��?%|HeCگu2~�Ә���3�@3p����)Z<�DLx�j���ӷSxFD�% U�'/_^"Q�#zU�r4a��3��á#+�jp19�0f�ǝ��l?f��Ą�b�7X�>n#��myG4&�?�7{��]������4�x��gr �����jV�lS�)���m��)h-��9�Qi>�ݥR�������)���L���=�����������2X~�.�|��Y"�r�i�b��I�J�r&�{~vq�2�
� ��2�@J��jb��?ÞK`0���CA݁W�r�K��'�Q�Y�R�\K��J&+�w*Ws=�6�wV O�Ku��a �:+xe�:�ח��	��}��xe!�oހ'c	��<�!x���#D����5�Cj��V�
m|�5������iq�L(�p� �Պ:�~t��|+Z����E��3����jpao�{��f6�Y���B��,���Ʈ�d۽��$���̰�癅���^���7��Vhj]��eÚvz�8ʸϠ?�/F�[��җnOcv��8#������W8L8v�~0i���?��q��c����o���Oj��0d��������%�
7��@�6���5��7D�M�P�0�W�!ؾ����e[n�\��G�ݑĶ)�t6�B|��A�<e!2�O7z;ƈ�,i0C��}���Hk0�Pt((�����g��������[_���j�w
��� d���#��1�˳j!?+'�K�E���� Bi�����n����[��<�C����1���=\ٓX]&�c��!�s.�3�©��^}���ޡس��Q�1a6��RaRS'�����˟��������\tH��X|!�s��*��a �^�q]�f���$���n�3Ә���0°��Xa!��Ǐ}�}�ݖ5n�C���$L/�7����������y�?�{����rE�y=����e�=.��	�-@Ț�J�]���@�o��fe�����#5�K\zGc��<8�*�W��͡���7L��>Bn��Z�\��٪^���]!���f>+]���^Z��ݓ5��y'ƢL�ԏf���dQ$E]P�N{����ߏz�!;�
��7���qW!#{E�?"���Y�?����4&�,��?q�_��� @��
��f�=^~o�ģ��
�e<R��jٻ4���@�1�z�Y)��J��n�()�蟔�Rj��j[��l�qC�rj9�2��.%#��8�C �/IGI*��TI*�ŝJ>%U�d��D�͢��
�L���2�34
Gڲ�[�/Ga�	&�Χә\�h[ڕ��SRb'=B8�ZG52\��I��
���@��F�]�{�<~YJ�2���F�����F������"a��%�����[�r�eU+[׌�~�t�~t ��eG���K��
0Lz�q+�M�Մ�|�5�ڸ���;�Y�7u�h��c��?���?���Do�,~dW��)в��g�7@��T
����`��:��w�A��4���0�W��b������� ��dћ%�O�~ר���?{+/�i�?���h�;�-,�?�Ӷ�m.��d�A?��?� �����������C�W�N
3�"_�8�N�e<;��z<��Ȗ�M�.���^>rG���ׁ�B�H��w\�r�]p�ӎ���p��Ϗ�����/s�w�?�9�
�s����BW��J�o�F�F{�d���7�g���Z����V�os)�$���r�?�����ArKUS�7\P�3�w{�GM���|F���mOZ�����?�8��9>.,�s����{��aZ/�k��,���z��V�kT.���� ȏR�1��ω|3�}��jq&G_x'�'�����;�p�OC��l���ϭ?�2��p�K*���S���D�X׈~�1��G�	��*�qo�\�n�U��^�!^���]�M`���������`�����ƣ���;�����n&���Y��|�����i�84��?���\��?	��z��(MEa���M�8�f|A�54�h�w�;�b���u�,S���á��;���x5�!���E(�h�����Z�r�\�B9�Z�6S��1Q����r�b5~��5��TY��������M8��>��mW�i
�;�aHH�L$�R%��I����L&�u�L�j�.v2	��)fv���������[���4�ŭD�~�89��Ŕx��d�N��H�S��bZ���9�*YDJdw�d"�U�6y4k�"�eE�8��v��VF:��{±�:w\=��	�K����WF�,�0��*�3}��kW+�8♇s8K��,w.2���Y�X��*2
�zab?,�ᜡR�����nBܯ��n%[�v$�d�c���ά��j�����~gC$q�R������C�d�jT�9K�r�li���N���4kUO�����.���v���>��f7N:Rg���22��LR,�g��XTRź(�Z�ru�$�;��z���.on��y����<L=�}�<46w��d'����	��D��x,�s���3��+z�/�'�5!��N��혜Ӳi���#^KL�������ڷ�W�&����W�b6+��d�I�ŝ���!qRGJD:�dV;[��ԡ��9N$���)�M�k����S�cz��5W]9oo�^�M;���\�-�'��4;ɺW�C�[B}1Uꈝ���W��-s��h�ӌ�j��j%��J�l�|R[I�k��rZ�&�I	�Cc�T,XL��*���s�zv��v���ȧF�}�N�3�H�� b �RcD������qj�p�ۦQ�֌�������7��a��a�� �T&� l�'~�7�ۦ�^�7)��n���v��]���O�O���h,6��㻠�?�:q���E�>ؒ�I�#*�Io�uI��O�{�.g�U��?�wG�L������b�^f����JB���������vk�Us�|��̾"r��|M.=_�6Jb.)��<Ͼr��g���A$�P3�%G4#u��<�� �*�u=Sv�S�����ϕv۶*9�ʰ�+��D��f^E�[r�zD�5�т�w�8�a�����/,��y������}}>���7�/�s�������$�ӿo���9��3��l�)��'�a���~80����3��ٔ4&���������� ��O�w��g���g������?�?��7?eW�"�5U�3�*�sQVUU��r,�p�h-��lT��JU�)L5�(+0�Ą������ ���������o�����_���������=�7�b�W��yH]]�/=�~"Z�����i,}����y��e˅���������i8��j��ҟ--Q_��#�e�����_}2���g��3@�����	q��X���>]�z��x��~�gk.���?Yz�"?���R���o��ax)D�������������?���>��o����o�ʟ������x?Ev[6|ޠ�g��\0A�clt��[�.���O;��en���R|"z�)�;#}�A�����ѣ���4I�{ѬG��D�f�w�1	�RiW*ᯜ����.�I��=����A�a����!��H|m&r���jZ=b��%�Qg�`���vg�OF�6R��X���_�,DaT��b5E�5V��XY�Q�o�S��jm5&��
���|䜀P�s�[#�[R�����
#5�k�f�:��B�lh���ޕ�8�^gO<��p�����8�I2=�0�M��n�$�����CC\Ej�(JEI�9��Ar1�|t2@;A�0웁 ��A � �A|rHIU�*����.���
���������=. 4��~��^�۬����8ف~xNޒ�R�6����[�׋��/�٪İR,q[a%��4lX�j0-}�\�V���j�(y}z�s!w�\�V)T�G���+X������G~<U�G�5�B7�H������h�+�"���?Wr'i�O���j���Q�8�Mw��>�Ǡ�����qǝ������:s��U��ṕ~��c�p/�{ST�G���U���م���s'�-������"Qr��h������
?鍑�n�\��H���?��5����e~A�υk���-Iz�\6��\��^�s�A��8] ���\���m�,݅Y��)���V�E�F*��k6yvp˩�v��%����~5�I�Om��󣤃\h���5\�e]����#�'{�:�,�Ov`��H^��0-�n�+I0�i�'&�h5;��4R����#�S�Ti>�z���,��q�UU��tl�>^u|;7�,����
������)�����.᧫u��P����w<���\X���>���.8�kv�O>\}���<�ۋ�nVx}��,�&]�'����5����M'���/�8�~�+�i��>��f�,�-%a�ʹ<x�m~ae��9N$�T춠$C=�K��7�����e/���3�(�O=���ՠ�����������0����
����G���J����W�?������>��G�����~O3�I�������̀�<x�͗_9�ǯ&��ג|ۅ�p�/��n�����X.�������L��fP��q�@(�g�!�;�je�M\O�ޭK�������������������_��7R?T�VR���~���i�,L������%���茶��i��/�9�ݷ��'��۩�����N��Kr��$5Xfh�����`�����A��3.���ǃtW3N�7W�����e@ ��lߎ@��0e礴̱u�[��\����I��N�Y_3F�����DCzs!��B6���r�Yk�NZ�NGoRaK�<��x���)*t���Q�)��	^i$�y�Ϣ��<*��$8I��M��LT��*�T���<�#��辪�M�����DN� O��r5h���f�����pߋ�g���8$$��V�Zh�L�öxm�df���,��9���JF� �Y�#Eʑ��I�r��yJ4C��`���	�RH&�9����R4��ܞ#+@=]�[G�*a���q+�i�HE�m{�ӝJ�d�<��(k���@�u+A�>u
�Fx��%Jʕ�b�H�W�	�.�6<u�Z��:P�����Evl晾�A��T��"��M��e����+V�'�J◫*������YI �� DQ��Ԟ�]�4y"Â��k7�xl��a�9��G*��FL��E';�j�3%�*�Rėl� i��$w�pI<f�P����=}L����}p�a,;L�"���<ꌳ�n�!8�����.ª�^�E�S=�.P��$�@j�PФH.��%�JQ�ϋ�(�R���*̘��� cU@�Z�Y�DM���y�3��,�����MB)�u�HN�4����\�I208ʇ�5�y��6[e.���\�M�!�H0�šd�����̏[�W(O�+��7zY$���D�v*,�3��@N	����Y�ɷ�2#��,R��$�sV�F�Y�X���s��&��D�6��y�Q�;P��_og6���'R�	j����6j6����*)z�a9�|��Ba)�2$�7�����txd�A����!A�Є+�J�-��	/�e6��u,(�)U��_��,\�-5j�U/V:S�Ҥs�������&�<�M+y��� 7��nZ�ܴ��ip��%<�M+x��� ׭߹d�Po /�I�������V�{��V���~���;���+�?s��ג��y|r|�1� �K1��N�����x�79���M�w�S�������8�ֽ��������������wi~�x��h��t,%:���ȧ���vb��c�o0�5�ݽ���tM���Ҥ @�r^ڕ�3�z���L��+���P��lM
�*�Qly�F�h>l+����5͙ ��R�ƌU"2�o�x�8E��p=m�Z�v��zp���`�l�C�M���+hN�4���Β.�4����Rhs��jc��g��dà;R:�B;T'Nѱ<��:͆k����d]�L(�V7��t����>(>cKzNa��KVM����+e��{�8.U��U���R�`ynԝ6ᨓ1�q�l�f��ˋ�V+B'�v$�;�lFd2{#�	2u�q�p�*-!�0_���kJ[o{������S�J]Xe�}p0@Jf��ihJ����Gy�Q9�95���1��U,Yjf\#�����j�؎���d��9�<1��0U��,�j�jZ��T����B�*�%bՀ�P�L���TIv
�M�"O�b��P��{o�ˬ;:i�����s�Y�����O?��Ot�ߧ��/�-R�N�� 8�H��������}����o>8s��WBL%q���Tq��8 �Z.�'e�E���	7w�{֊;ϐ�⦑s�Q#�Y�]6��
�İ�i�uT�V�QX{4~��V�x�K&�X>ob4R�����"u
�EEI�� �#gF�;�3�H����Xw7��5ւ��&�G��c�Hr��/tJe+S�M5�Sёo��Z�b}t.pݠ"�H7j��j2@A$�:6q<�Z�-]�E��>����$��Q�X/Ħ��s� %�'�"�16ĸ3'��-fآ#:x���E�C�`�"�u���-O}�td�z$:�� nd�K#� &��Y���,뵐F6S�]�B�6Zb���ZO1��H���c����ӣzP$�Ee��ǃBu Ѩ�M��[��<���N;c�ѥ�o]/1�,���K�ޚDQ9^�V�������� `�q������ !���@8`��n���P�b��t&�t,�S9� F���%]��Fc,�0����%pɘ�v>8<Vȫ͹���Mh�ݝ��5�X�6X��NhM%Aو�����ǁ����H��#K�l:���ZӁ��ʸ��F�S�jj�7�y�fb����A��
A�������m��rƏjC��a���$�ڥB���ؽ������s��9^�}�}�j���V}ƢU�������w�v%a1�k��֤v1D�!�@�H�mB�Ok�!���~đ����q8�ڈ
��#�.��)�`̲�!Ub,�F�FY�����p"ؕ�ǌT)�$�4`��VC�װ��oX��KPc�I�c]�y��Q�~�˸C��2|����:��tx��͓�j0�Zt��{�|^��j��\w4�Z��U%��E#kP���xm�t��z �[�Ks���4F규<�{���x�Q�-�m�<?j*�K�5���p��cԊ9X%@��j�ȱ��������o^W�0���F?H}����Z����둽�����?	9	�^�����/���hJV8����a�����W�{I��5'�2Z�7S� /�~�?<-�}�j����έ�[���7?��{�|r�2�/x�e���ϧ~�Y��'����;�w�U����;窉�x�������'<_�@%y�j���狮w2T�o�z�����1S��J%1߳�!��ŵ����:A�&Ƣ�8�����vxs5?�i��0��ԯ��w�U�%EZ�|0�1�'�p |n���S�Y/���=���w����߷A7��Ͳ�-�x��G!A������l�i�E!x?��Aw��o������n����_�j��{�i;���?�����۠�����,����6����Z�]���������?�n�v���A;��E'��5��C�����;�ٌ� {���;��ؑ��¾����(��_������<����O�B�>
w��s�G��Q��J}>t'�?xK�7���n�vl����S���/��w'�?������߻�;����c������|+����b�}?��X?�]/�'�;a���?X���A;���WW�# ;����b�w����{���3���ax�t���o���������//:����K��+l�iE#<�����3��m���}�Ƣ��GN.s�K}|Zm��ruO£���� (|]/��>�P�t���2m&��M��"��*�Zf ���#	�
�n��n(%1�����(���(O�8��/�Gsu��fw2T2p�
�)r?�G��Q6��^P
.n$��'|�g4c����t�2����bQ��r\���� M$�"�Hk~�q�D�՗z-hN�@�l�4��%�]+^�e׫��ӝ�����b{��6h��_ך�cd������������(����;�����a�l�t�@Q113gq���b����z;c����kC:�gs9��نM�q�����Mw�Q���ѽ����פ�{:�yV;���B�uR��4S��؀(:�q�W�K��T�B ��d\k4�~@(�ћU��C�#��D�^cК�ñ>*��a줂s
���,9���Y��Z����nD�<<��"* �/�*N(*�o��޺WoM]�9Q������H�r��>��#���(/M7� ��v�͢����ݹ>�{V�S�f���l0������{zS�?p����O��������?����K��g�Ɂ�k,�_������FhD�aU[�����~����{{`��a��a��7��"�N��������$:�8&c����$�r*r*�蘹���4��\�#����#h�8��W�
��W����3�غ�*M�-b�!=ns.����Ul��wm�[����w�S�Eܞ],�\�W&T/{��f@,�Ò���RH�bp�)����'�vb.��U�>�^��*���6_��U�����?�>�H��j����MU� �4q������?��������f�b�q������������?�|cES�����,��&��o����o��F{���/���L�1߸��}�8�?�j�/�7B���d���
�?Jp���+��ߍ���ď�o�S�W}�bk�4��4۔ŏλ��b�V���?���n�6��zTh��i�������\k�Z���&f�w�>������ W�v'��={YNuZV��er8���:>v�x��]�Rl1�¸^�������U��f�G�NW���]��:�W(������}S��wW.��69V�P�v��ɲ){6i[۶B�ԣ�D��FmS��!=��BS��_��k�1�J>�v��\�A �T�ЭN̬�q�fC�+Lx}�ˊ{�@�c�v��V������ތ�GC����=ǒ�B��ҵ��}�R���_�@\�A��W���C�� ������?���?����h����������?�������N�=_���,���`��U�G��m[�mNyy�a�J�=�SN�[Q�K�z�L�����CcAF��wV^sb?������U���M͟�a�&oy��]O����/��c��w`e�.��ߺ���ͭ�$��6y�{�)�7�B�>����<p�}�d.ʀR�X_
���f^��c���$/;����?���T4S��1��?���A���Wt4����8�X�A����������?/�?��4��?�O�㛢~��k���?��9���������O��	����7���Ԁ���#��y���	�?"�����/���o|�VQД������ ����������CP�A0 b������ga���?�D������?������?�lF���]�a����@�C#`���/�>����g9�I�y��j�o������Ɵ�ߘ�Yg6�Z�9�=��E���?���?7�sP���uRt�Y|����Qg��=Ic�'���9���L�WlG�/C"2F�����+�SS[ӣC���؜�vՒ.Z���:��r�l��e���_x���n�?{|U�༿����^.d��T:�)�lev�o􏇛w0��`u*�,%mڦp���޸���Yh��V���@�TfQ�Ju��E8�Y�.��O�k�j�B ;�B����p�a���EZ:v�{����N9k�1f��E�=��W����g�&@\���ku�2��� ����?��y����p����r!��<�������҂(r\������H�S"˦�(�,˱�D�C��z����78�?s7�O�σ�o�/����{w��/C?��ww���V����Go���kylx�r��a��q���k�.f����|�XO��raˣ�,�^�PXeXus{<��6�z�
q����rLȋe�/'�Н�r�M�E$h�Z�_&��If_І5��X�����=�)�8f�����t4���� �;px���C���@������������G�a�8����t�����`��@������Ā�������D���#�������������������������B�!�����������Y�~��|���#�C�����g񽳷L����|�������8?|3���o&�����x�Hκ5y�d�,������,��v�����kf����<��Q��ڛ��Yk�V_�K5�/�l#]��za�aݕ?|����4��9ao�x3*zt6m��}�Ǫ�̔�N��J��e���Ч�XwO!-����G|�td���0'�5�5�4r��J��t��u8=�?�eMg�q����C�<��c�ʲN�ۡ���-��۪pݒ���[��s|2Z7g>-M]����'��	���p����ux��e��9*]�����+�\����'�1e�6�P%�ߥP:V����ݒ>��j��2�_O����۹���0^��}梕3�mv4��O]%ծ�ږ��X�;��=��Nn�e �SA7�u��U.��r-%��$�N_妄k[��l��q��M��s�dI!F��z���)�Ͽ���n��� ���?��@���]������\�_"i:�*ɲ4�i6ʙ,⥘�D�ᓄgi�Is>�$��h>gE�f�$Ob*�3	�?~��?��+�?r������ق8��Ó8��"��0��?�#�%^?�Xc�T����vgmUI�I��[uƺ�N8/����T�>�}��Z��|(��,����v����A{{���)j������?�����������	p���W�?0��o������q����3��@�� ���/t4������(�����#���Bb���/Ā���#��i�������=���+�4 7GS�����M��r1�]6;���,��4`�����{��.�t���S���-q�8�NG��� ����k��Y͜��l�|�媥�e�L�j�V]�?O�۸c�u�u��t[�6��Q�ߎ׬������֦��҃�b��]���%������%	�����<��ԙ�'b������XS���cY2]�J�EκQJ���D��FY���{�ӝc���3�H���2aG�2Vμ�o���?��q��_�����?,�򿐁����G��U�C��o�o������1���E6����?�~`�$������=]�[��7��닾#�K݅�@!	�����q�&U	�l���f"�YA��Q�P�0�+kL/��sZ���VFӓ>`]k�O������<ߢK���/E�z[Y�i�����z�YAMe��ц��{ɫ#���_=YU4y���n�9vM����滍��F���@����t���j;>����y�/S��Ү#�^�����V,�5iC�[��k�����ߥQ�E��_�@\�A�b��������/d`���/�>����g9�������[����N�/����[�4_Z�|�J��P����ǿ���B~��~�{뤐O_���W=~w��RYZ�rf�cW��M&,����epȧ[�= ��<���p��m
R������u�F֯���j�դL��u�:EX(������www����>�����^.d��T:��.��Z�C�#�j�g���A<�fd��z3�L%�)��A�U39u�8`�׉�{��ӎL�eSs;}�Cw'R��6���f���3�0ҋv93�����˼\�uN�Y�2g!"[ӽ�:�Y���Cnݪ�K.�-J-�Jte�T�6��������/d �� �1���w����C�:p��J*O�!9��DLQ���(��Ȍ�D&�IA��/�|D�t��#�<$�~��U��5¯��*֫�-�Ex�egA����=�q)�g��9�vZ�s���ݩ5�)�t�[c����h��kӉ��n��t�
W�����8�Ƴ�$_)��z���vijb8럒�<2��Y���������X����ߍ����D`����3�����5�/O�O��w#4�����-M����S��&��o����o����?��ެ�cy6�82Ϥ8�2!%�OҜ�R*�RV�9I�96!91a8�g(!�.��4�S>���������� ��~e���7�s�+I��1��C?v:�m���V�o�y<���K���^ר:U����[��b�i����+Z�2;�X�{tN72����e�î���W�b�u5��ϳ��YQբ�F{�����}���0��o����� li���L������!���?�|�
�?�?j����? �����Ɗ���G�Y8�� ��!��ў�����_#4S�A�7�������?��Y�ۏ8��W��,��	`��a��Ѯ���7*��� �W���������Ѵ�C /���o����?����p�+*�������^�����ρ�o��&_��3��MД�����j@�A���?�<� ����6#�����/�������XDAS������5������������A����}�X�?���D���#��������������_P�!��`c0b�������������C.8p����9��n����o����o�����/p�c# ��Vٵ:��D������P/����7.��E�Ȥigy�ё�K��e\,r'�	�1�$l������Yl&�+�b���������O=� ��	�������ο-�����<ה��4+:YG�ހeͥ��][��j�}�W�~��~��<p��
���TD�P}kU�S�v��N���͇�$�J��d�o�5���m_�1�������'L���PMS�͆kx\�Ƴ�y�N&w8s6��)[!�O8���N�"�J���IFc�B8�+G�͘zC�W����s����l��u�(ge@���6��Iu���}���������y���C����u�^�?����?������w�� ��3��A�O�C����`�����0��?���@��������������z����w��?6���?��������:� ��c ����_/��t������9�F�?ARw�Oa����7�?.��(�t]�e���%8��lPh�����+������?���d�z�-�}�yH'ߐ$q�����I�ܡ�`�RMCg��f�2�]�C��M�G����o�M���������+�d�jԹx�v��}9jJBõmmأ5��@�V�j^��.s)l���-G�K�yJ�,��IK�`����Z˴�<wrC�|�b��oc�߅^�?���:� ��c ����_��t���)H�L�8�tS���d�`C?"���A�=!<4�#*�ɡ��(���5��A�Gw���Ȣ�w��=�xr�,��[����r�Y��:��v���z�9���N��N��`ڰz�a�բ�a!#���qw�-��=�ܠ��(h�"���`���0c��m0�FSߵ���4\�����?���0:|O��?��G��k���>���?J������?��_y�I� ����������V���?�0"�CT8�� �I$1N{�0�j��>u5}�L�̐@F��nD���A����������V�;��:��,���Q��܆J���9��ĥ�V��M���͗�GC�Oəݮw�zd���V��L����\�P��/�ZOp(���H�P�S%"���g~(�-9oRr�_T)/5����������-���\�E[�������hp��
���҄[�W�u�k���yrS3�ԉITw�_n���Fk~�������*���j��~��KrN�[��_��z���������疵��M���)�O��vqI�n�}��S9�y[@���+���ƽ���� �u�eT�Uy�sIn�pܤYG���e���p��_ua#4��,n�c�.��va�ϳ_:!N=�J|�Ob	[�sM��~p��3��J֦J:��5D��?a_{�RI�t�b6M(T�p��S����lA��!C5WeR܆�A�,v�ލg�k��LR�Wd�(�K<H�����[��_8��	����^��������?��/ ������wwh��_ր��ޠ-����~w�C`���u�3����W�?V�v�n����#!��X���������~��O�H엙�ї���������R���R�Q��ў�
�5�@��r�euQ�X�2�`�S�p�D�����tk�D4w�)b����e˜�K���
�]����KQx��|㣾��a3�Uo���/2i�\�ev2+k���Щ����r��k+R~���3Yf3{�kds�v��a��|Є�*��D�3�-"<�]c�#[7�T�t-!4Ϩ<_�<�l�RsF$e�w�I �K���bcFL$V��s�/p������o��������?��/��������wh���C�~�So*���E�?B>����m����7�o�/���>8Hx�e^���j��M�?����^�w�.�F���9mw�|�w{5ڟn^�]7�k[��-�GxGޭ<�� �/�~!a,�d�"�lh�6~�}7Ȕ>U����:�/����.o���|�6��"�DKی T�3+㾴i|ɶ���s�<��/�>2�8G���Q7PÝ��� M�%�cvD��*�|1Ȏ�y��s�g?}5���/�	{��茟��+��aTqw���*]��4�甴���"�Td���� <槈�<��ոL�5��{36u��ftI~�����@�oG�T���9�����	�6�V�����0��{���MR��0�R� w�N�?����pwQ��?����pw�;����8���!�Fc~k-�0�K{ad$M��G�;��4G��Z��̞1"F��	�{1���h�U�*�U����Q����O�A�sy�H���-v�.3&�OeZQ2��xS*���?LX�ݴ�Q��|�$s��-Oɸ�<L^��e�C�TCȦ#�>FO��ȥ+Xu���ȯr��I
�BB�1W����1��E(��_���{�@�����_`���՝�{���ZA���~��>�?�zP�E��ko���V�MX�e��؛F�*��]M7Э��5`�u+7$��UY�`�3u`�|�~c�5BA�˗�l �>�M4[��'s�amK��7.z`���F��-�e�PFp��Q�e�:�Vg̟���J�$2�w�7̺�N������ѵ�}c��:��oW�`��io��*AF��q�4[X��(�c�����xw�73���Q'Z5u�B�<K��$)�{xF��#Ȭ ��F� ��~��_@�w+�J����A�=��	���
@���O7����t�N���s�A��������?��4��z�3˧�(��B��A.�˙ƴ<�ݺ$�7<���`7-��_|ݝB���|��ʜ��k�w�$/��9����s�~��Q�j��%U��1$��J�k�6�s��.���;�1>�@�N�A]F|�Mԝ��e�00r��ł���f�����%^-�r��O���LJit��]���FM��)��<����������=���#�q����?� ��c�>�?����w�v�T���>�P�����?���?���G�_I��������ۗ��Y�;������'���A/�������h����>�;BO �����!���/��t��`'\? �������������E����\�������
@���@�����?�m�?�� ��c�^�?� ���ZA���� ��c�?������?����M�f����?������?��t��w��s����?����m�-�?���`�j���ݣ[�$��H�`5Vf����[���������ϙf܈s%t��ܻ�9A_�dY����'�:�2L��=7"k�S����$��:���e��2�+�@�\�l9'���މh��S�>/v���,�9�<X�4*v���ͥ(�[�^�qR_�qb3�U��K�Y��2;��5��c�To��e9��5
�)?�[ƙ,��=�5�9D������UE���y�E���4�k�sc�&#�ʖ�%d����+��ՂMYj����N=	$]`�2�BVl̈�$�*~0w{��E���[��C係��VЕ�ˣsU���n����}����?���t��Q�Db��P1��8�\*B��~4GC$0�j� "������~l?���8���?	�x����ĺ��O��|����jE�%os�x��]O��M�ԗh��J\��A�Tu�Ц)傹7som���G�a�عX��Z�O������f�w��T:!hOQ��e�4��-X��g|�E������Is������r��h_m�ݓ����p�G�;���-�O���@���h����������^�?M��?��h�������@�
���w���`��ZA��B�:�����?q���?[B_�t�v����g�?QP�i�����O���m���_P�k��?�9��������?��@ ���^�?������A����@���O ������� ��t��@T� ��c�^�?q���?������G�I@���r>��������V������R&�jx�����	L�ٿ��%���7���[;iO���[�l�{
��j�����g����A`�@�V���	'M�ds�9%�p8S���l"#��+xa�aD���s4gsmն4JWr�7�^�k~��8�}�61�t)�T��FH�-��f�9V��Nn]	Э�?�u��D_I��q��!�y���/M�zu����8^o�v���C���?��;���>�V#\��顊�j[R�1�	-�:ﵺzbSV���Lp��a4`!yGL��9&��`W����\����?B/�B��ώЩ�!P���������8� �����~��xDz^�Q��C��*F�1IE>I2>�h|�!CQ
� �)&���d<����?��>����O�0�˳)�����#d;�|����S����<Kms��s��"8��x3-3Je�.���$.\n���9��	)�̖c?���LN��3Lߤv�˯1qj�G�N���U|<�O��{?��OI=z~������7>�(M~w��a48�k���Ow��Uk��'�֟�ݧ8=T���p(��iHw�'o��te����BUT���g�q$�jgf3�sggv��;�F�Zf&kz�*��v``��W������r�����v�^�4H%EZyH�Y���(+"E�G�%�e?�������RP������L�f��ħ�v��so�:u��s�udW��mrC�u��2� S5�����
�ݝ�oG5~��ׂ�����+"G�����;���Dnތ��\��E���^�Y TG�j�ݽ�Ȯ~)v�άߋ��o�ݶc7������mtg��\m��TCF�"9���h���A���$��;��m۴�HO��������ZD���p��W ���	��KWD��o��ax'{�ok����q"Ͽt����i�{jm0:r�#X���l�Zo�.�4%x�������4��+UH����u7��pp�s#("+�l!WŅ�ݘ6Rb�����{�P'�e}�q5m�s�|Q�?����9a��T�Gv�H����c#Y�WF��
��hУ��i�^����	e���> ŝv/s(Kw��ޝ��:9�)�X�a���)�����$��qx���
��/��@}���ŭO��g��;�V,�pZSPUWQTђq%������UER2�P,���$�PtYi��ocq%�%Mc�4O�a\���������o>��~�ן�߿�?>���2��y�����M�
�pwݞ�,��6t<�����x�e;0d����9�C�A���������~���.�[��s�;���B
=�tu���_;�=U����g�+A�UAX�i�z�n�����2`h��ƿ�������>��7Ͽ������pG�>������x��]���?�@�xw��<�[*���c�M��#���W �lG.�x��>��OD_���'���_����;���{ot�O5կ��D�}�!���ֹk�]�������H�F�������"�%ںhEi'T4��TX�S����T2�m��N �$�R�D��m4�NhI��*�$���}�����w��̟}������|�O.�~�;_��'�������Ń޺	���	R��7�o]?��\���s�Bx�{�Ao=���߻��88��k�A�j3.�D��1�{����nS9W���	xc?N�2�֜I_�a8�$?�Qʬ��e�0c���Z"RˬE��*��5�'�1��%qNl@��H�ejH֓뭉�Gݦ@�Y��|�)[���֬YG-�Q��s��ʲq���n�<z47~��O�8���}�%M$�!��\6O�%��՜Ke9�7�y~\�g����gt�kt�!I�[��(]29��UT�^���'W��,�	�	��[�4w^�i�^������zB��0�Β�e�F�$H�,�iX��Z 1Z�[�y%��Ӂ�aZjGc�W�L�Z��������"��I��t�I6�6���"N��O�#��y��2�D�8�*:i�,�:<5)���!�v�Rk{ݦ���`����<��҄H�<�^}�!RE�C�☥T�Ae�8&A���X<�d�/(9��t<��x��B~��e��<,��,\`��m	�Ix���4B����ELQ����f�3]!��`P��*��k��L��X%'6�J0�r����l���o�^l�Kd;<��-�{Y �HK���M ��o�LA����-*Ѥ���|\�`�U�����(��i;��c,��?~��2~���i��gi�,��\4��%��b���0�-�d���*岩*���i�CC�._s9Ew�Zr>Qt�_&,�].�I����5�(,��ƃ2-�yf���E�>*NfY#�j���2d0���rW�q5in��F���yZ"��-��T�$:ݨڝ>C�KL'.�6�cĖ;�A��<��+y��c�zU˲XM�y�W=�,G���,�a���4�a�,�M�k�e'#z�t,>��!I��l��2����Ĕ(�Đ���,�k-ɯ�+�;SEwI�x���P{�X᾵ܾ�����Hv�
Zh��;h�3?�1C�9����΁��Ѕ8�8ң�yS����vr��z˥���8æ��M@ezZ8�ȶ��F��|;�%ʃ�������L}�t}D�V4**5H���$=$[l����R
��yî۞%�n�U��$���R��L>���&�=jXOdsLdR�{���X�j5�vz>�7Ҳ3��c�MP��W����J`?���q��F�03&s�\�V�FJR9&���)�������(����
��ժn<6)&F=���3S+;�xM�����&�InO�&�*x���t1��b�{Kѝ��R�נ_
V�ס-�b�y~�����uoz�j�Ʒ�_?����ڂ:\!�dM|��쯔��z�&�����_YN�_�}�
�+���s�#��J"�/
M�'�Q:Vd���z7&Lޏ!��&��Y&�ǐ�`I)�)4�8`��5yq��^��jIm�_M�͊�e���T��j�#����kù+�\1)֪Mc2}���-�k�˿�w"'HbkG5��C�\����/�,X��i�S=;սr"�>>y��w:ܯ�pN��|М71�p�Rsd��T�7�7�����=�26
�f�F�h�M��j��Eɥ)�3�n�,���h����~���M,n�i��iUV�S�t��4��{bbK{�}jbOM�����h�iC���Q�:��lMl���XjN���N�������(��O�ܼBr��f�A#37U.N��5�+�$�N�X�KT��m��z	��\��՛��Z��cS��
�YO�nb	_���j�m�Iǫ��߯	T�4F��Ȧg��Fks�(�:M��5�ro�9�*8<[!�|���ҀI�d�a��"o��1�<��Eކ�EN0��1�,���/�cW���̠砧�.@[�c9�pe��*v���A�~r����a����߽��گ߂�q�ڭC��z��ٜ>�9}bs�ĉ���?�_����3�/�Zk<���@��F�B��#:���r (|���tv'[���t���DW$+Q*֎!�r�g�z,ON�,�(�z�)��yM��j�:�Z�/v��L%=;� �f�Rc.%����MHI�'0�&�#���鎧M9V8�7�C>	?�t�oR#���9a6u�n��0��r��J�� ��Q�6����y�����������Ō�Wl�#��eP�V�XE�&��T�i>�i6q��~���sl��8��m�c�z�U��[�3��D7�óG?�P��Ջͯ^�|��ũ��ā��6��s�����*���go�Ѿ��썐���mV�_��hr�7��bG"�������J�#����f�]�.�'=��l��^"���͹=]�����|����Z7O/p��9���S��|�;;�~$xg�>׏d������l���"Lܕ䞩.S�O�oE���Z`�;�m�=�	�:}
}��_��.�ТoJ�{��p�,r��m�$�gV�ipm���:�<O��mp㴽��g ��[����6��l`��6��l`?����CX� � 