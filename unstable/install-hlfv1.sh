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
echo "Please use 'composer.sh' to re-start"

# removing instalation image
rm "${DIR}"/install-hlfv1.sh

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� /�BY �=M��Hv��dw���A'@�9����������IQ����4��*I�(RMR�Ԇ�9$��K~A.An{\9�Kr�=�C.9� �")�>[�a�=c=ÖT����{�^�WU,��͠bt{��=M5M���C����� � ��O:�Rӟ�C?��4C�T���(:����zK����e�& lS��j�u�?P@�R}<f�́�@k�  �Ǆ����_�-�:4�t��&�n�ڕ���5�AS��&4�q�ԐrQ{�i[^� ��8���?��2�T�лP��HBA**b�L(䓙��֯ ��� �:l�}�]����hU��=hi�f�J����<��p��S-�kP����}�,�T{�FL_
$�&`@���v6B�{Ћ�8:���m�.�2�p"q2�j(A��\����.4�6j���ZìC�
T�r�n^�3����yi�=e�$�^Bp(w{!��b��K���+{���Ғ�����������$0N�l�R�����X�cV[��C�*�<���7�ʝ��Y�o!-���e�sSB�=Q!q?������V��O�Z�'Vվ�5�mU�nh7E�W类M�Ճ��XT�<�p����j���o:���.���#�C�����ʬ;�q���7���u8b�F2��i�I>cW������(6���a ��s�>����m(�u��9MK��a�j݉��v���c��Q�a",� ����o#��K���dM�Z��\%}���ݒm�Q5�z��k *���뺪7/�B��4BAG��S�5A��GO��=ϟj��G���� �r��sܥ��2TZd=ܷ��.�	 ��- р%���a/�Qp�t{&*"�����3+���C��_���n� ��t�`)&'4���F��-�@��Db�+��%�>6�̯ge��y��UL���)�����>�g�S��	COt�md6`I4�ǉ�O�O~�4��s��е�+�)����Y���.��K3�:�����.��+�U�m�y����n!Ay8D��5([XPC)pZ�����oA��Z�O�
���a��:_�L,��;�@ձ��^~��M�9b�˪0�G.�$��'��5�� �L(w�?�D��<A�D�|���C��ˡ%+D����lÒ�"Ϝ�:���f��h�q��0KG*���Xx;�o����
D��	P��G]5q�����*��� ���O૯@ϩ�o��zq��u#?(Xb��������,B�[��l��Æ+���j��m������K�ٴ�f����45��"���7o�����Ly���^�:R���`�g:��P�o��	�^�����ؿbBن�U<g�.����?CŶ��f`;�ذ��/u��h��d���������o�$P3z�ԕ�3�Z�Ļ<��6ފ1���C�2嚷A�7M��P�sD�6��3���P����#��fT�{W���>~�z
��c̒�Q� �^'9����r%S�?���2�7�f�j��nA� [V��	x'���\���Z�,��O�#�
|�h�
1�w*��T�r������Au5�3h�x�Y�ĂHYu���#̴ާY��	���K*����#�Tb�K��%x������#�W��d;��XZ���6����֠ �~�<w�� ��b��y�y�� �b�D����E�B	̎���3�-��s�;�����QQj{�g�^�����(X�����������b[�o����l
��$�������&`����gaCGs�i� ��a~z���:�@T�+�h"D�8W��/�[G���J�o��{\"�G��Sj]�ٲAm��a��c!¥����3/��`c����oĸ'l~L��u��.����?����px���f�����̾��� �r��^�m���!��S!b|���~���Ո�a<z����5h��Z)�-�(Pܼ����-�}�U�-ix���k�w�^��CQ�E����l���������F�� ���s����=?�8�2�39u<Y3��K�.��s24y��e�`��г-�E�yq��z���B��uf��#��#�+ώ#��o���Z@7�hP�L��n
���n(`�����9��Ę���F����;�����Y��oٶ��:~NGV';"��m �Br�85��,ഠ>y�	��D�� Ol��+���&�䭖��,�*xCX�����;������G=�+�*H�  ��YQ�g����J1���R=������\5�OB[!�CӮ�#�v*���Ϳ� �_Uv���@`�[� ��ɋ�X���ٷ�6�!9A�C$����b)uJN��/�6~�`�R��J:ؖB!2Z2�_��O,�>���t}l�7 7����\�Vp4���*F�s��0��v�����xM}��?���w�����&��;:�ި��#��Q\&�Z��219V�h��#tXi�J�m(T-J)qV�l<�� �wh�;��ү��6}�/������E�/>y�ۏ���f�W�1qIt������i�"�li狝�?En�A>t���v|�B��-4y�������W\�xY��?~���v9����~f(� ~�zak��?���b���Q�O�L������>��lR���������{��;Ab"�����?�����~�~��/�?O:�T�dx�O;�YjS���	���B�7���i-�5�����l8���&`��O���0k�=OW����@/t
�]�;K$q1�t��%+b��	ŝ�9��,��n�
��}��}���|X->>���� �JB���b\9�*���|��]�z��u؁���'3L]n��h����e�̆a�mD�E��kв�����.S�5j�ݨ�ġ�D�3��#C�*�=�B��x�n�߅S�
��9��Ƙ:�2��u��u����L�]�i�_(6�A��,�_�t	��z�}�-�b�����\����x(����o�F�T�b�K$�b��O��?+��g%S��j����Cdj2�[b@�t�v�*+Ԅ:�T�OV?�T�J�X������/e�|)J��ꪹH�g�M�'�-�2��ڭ~�G�ʚ�fb�Ӆs��3B7-\6���8T��A����!L����e��-!9/�[۞{ي[�V��{�oJ���0s}�6���-���k�|�n�Jw��C�L�'��L������I�-òɁl�f_�C��5mI��>��+x��"����Sn�9��i.�
�KL��$D� ������k�B`��%M��;��V��n�04�p�m���3�5��1}����c!eO����8��n�����),|���Ԅc�|��s���~s����DAȢ�K*UO4gy�zT(g%$�����fu(&R�m��UE��W�x�"�x76�_�/�t������Ro治�����t׋t,�qx�K��㹚�o��i楎��ִ[v�\�j'F�7kC���ݍ��>��s�j��5�K��^��P�=� ƽ��	+.au+���+O,�1q��n��L�g���o�t�=�j�Fd�U�3���X�����Y������FX�ޮ�n��E���ƍ��З��7o]���m�S��7!2D~�3�fN�;�������O���f����> �w����o�}޺�(�{�����~�-��M���?��������Qf��3[��	،�w7���;���p��������a�y��Ƣ[��	ظ�_~�ur<�}��C�M��+����|Y����_� ^Le�@��L2#pU�-%�LFȶ�������f��9,EӃC�E�>?eO��K�.�,�l��:�B�TJpmޑJ�C���a����bUB�8�@x)[b��|t:P�l�*I|ɭ�R��I�3��89b��q�]�O%^���R-�B�*�SI[I�\7?�U/q���C,"q0�P��GI��Pjs�|�TFe#����IIkH���?乓*�V����ceD��89�N���ZWkI�'ɹuiѡ�'G�&Q�_�j�|Oa��w�^�D�?�OSt����a�{99��Z����R���I�����6%p����=���D�ɉ�~�RKv��y����s\Ig�����d&�D�0"�&���y�QH=�F.��#�j�§�ʅ 4ب��亃��W��$���2U$�R��9���QS�%,���RI�8#%V�+$��y�s�:�y�)	�9Y�$A�^ڼPr2�4Tf�?���iX�j��1S�_��q�0j�V�T
F�p����zf��D��2�i���5���R����q�^���)-I�*�F<q�j��y�GQB&�V��r�أ�����ճ��X�����RT����Ekxߖ�n�>�tt!��R�6��l&��'Է��}�m��a����3����6��l��o���!�g����n��M�����@�?����2WԳ�J�q������n��Y�D��j~��(	1GH\���[�px(���%�ͪ�ɷj)�����|$�m���S��CT��)B���.N��0U�=�*�vG�b���ժ��i�m�j
Grq�%HN��䥪����T�8R��9�em�̙��y���wY� �:�]�1��H�)����y�"Ev���2q��#�9*��9�Gh��j*����\�YL��r�ivӕ~NIV�H�Įu�
��܈�4�n{H���n����C�V�jd�������\�u����~������^�;��OWD�͕�f���4����K
> _t���5�"_�x�A:^�͒�����<:7��9q�,�8\����\��Y6W{Fj��LT��s�O�|�K�IN93�;N�q�v�煃a3��2��������g�j9�~a�E!#4衚hf�O�&'��� kV��i�a�n)*��s>7���B�}��hv���m���L������~�6�������:�������l��Ͽ#�5k��>�>��Բ������5�?_��9����|�\����,qq/eu���:Ԕ��}O�m��3����I��J����5'⡾� � ��^bR�D'Z����뺇�{��>���Xv�W�{��I�ԟܶS��k%rK���K-jl�{7����w5�۠��1�O���8r�J������k�
83�O<K�8"��T�>�m]�����-����&�K�]C}��(|�W	��sK�§�*d���u�P�Y��a�����zf��>�tT��!F��׳���{{�G�d(�4h$������@:^�������y�����Ρ���X �ၱ�=\f?�����A��K�p7�ܫ�|J����䕄��.�x#ݨ�����&h����O��B�������������������Z������;���_��'���ѵ\N�R-�ֲrT����O{��O�ϓr��_�c��e������mWua��55X���Y��7Y0~l�o`�ϦEX�Y���El"�T;�t6����������������n�U�$���x�敤��2���7c�M�/�̧���6++IϫkF�/Inm&biē�/����6Y�,ǿ������B�G0O��@�����jm�}�i�������
���&��������M���du���?<������?�$�	�_�e�_e��w���9|T@�A����Y��_�+��%���x<E1dʤ4��Y��Qx�qD'�T��1'1C�i)���{������S,�Z���5�7���5��KW¯�?u�
E�^�MT�:z�M�����nջ�v"7[��}yi2~0��y'Nַɝ�jTIM$�̵�����S|��JL��]dU�vK�"Đo�Nh(�����[�6��I5_��:��=͍\G�[��������c]��lc�zSm���?IP������C0|�ta�������h���?÷AS�������	 ���!���!���?�o������?����o#tF��? �����g_�����7�?�����g����1�+m"^Jm��ˣ�QT�ֿi�G���?rCĿnQ��ʖ�����g^%/J���8/����1���X�7b!·:�I��k1�eAݤ�nE�7��Bzk���2��_��!��<�V�2,��k��M��`'#�kƇ,���6���6���Qž�y]��F��t�{}
V�ʡ	a�7�+�W��}wX�.\ϯ�r�����)sV?�]YFQ���(���JQ)��n�uU����X@��ZJz�n&=^�o����[�M�e�_�F�%#G�l'�?�k���?�o�������p��-:����[���Y�'�O� ����	�����j�;����7����I4������9��M����{4��I�QN1lLFQ�p�E�QLβy�d9�r9EdL���4��\`#�泈d#8��ntA����&`��~��on�b���/^U q���%�c6��H�*n|�G�[/޺����6}N{���Ӌ�UWk�F��uo^��i�?,�c9K�Xh���va��Ca��s.���逆�\�27��J�������.�����o�����v�;KS�����$��M ���������?@��>����?t�&�����g(��o�.�?���M���3�*������o]�����hY�������o[�������gt�s���/�T�>� ����x�a�<&��yJ�H��i:�y��i���(F�~�.�����?�W����T�ʥf��d���]6� ��bm���|�+v��l�/���X�t(�*<rk:��6�z�rq��Z�j���r�Q��^Ii���{���8e��K5����%�Ӆ1�qM�6���P0��V����������?�L����	����?��4Bw��D۠)����O���0�	�0�	�p��-�p�Cˀ����_'��Z�3����xg�������B�c#����|�Ȥ�L����H?���������}/���r�~������'�zY{�B�6v��)u���®hI-C,�'Z9Gl�k�P���p��dj�_��'\5R�ˣy���\�j����?���8�	��Wي��?nI�gp�fVΏ�:�?�p�q:
��⊂�NR���:C�Ø����7����p�ï��?���-�p�Cˀ����_'��h���?�������{@�������?�@����zzB�G� ����N�?��F���-��߶�C�G{tE��$S�#�,K㘤���"V���'(6IX�ĩ4gcA �ds�'H*O�$&R2 �����C�G{������#���>]b�]1>��fl�i��	"�GV��}��0�4�}S!��������*�/��v1��1^2J�bd�}j%�X�����P9�,���Ĳ��#���j�<G�
�?�J���h�����h�.����ڣ�������6������0��?0��?���_������]�uB�!��5:����M�w���f���ρ�o���z���P��s����m���3��/|q��{1�ߌ�/��ᛱ��8?��^?��A�_'w���j��6q���k�ϯ�?^3�+&ݑ�yG!t��s˨��ok�ԕ��j�n�f�0���O�6Tj�	}������7�*!'������,��\��D�ė� ��7�D��9$��1X�J�/�*2��ay1̉lH��;���>N�j^ׁ=��]�d6�fr�$l�ђr����:�o�˺�`�o���V�|j�%)g�d�o.l4Y*����oj�3�a�E�p�~��ux�t�4���G����T�5��d T�u(c/J)Jf=ڡb�$/����ͮge@���2�hw�.�6ٿ0�ʞ�6�?6��/�J�U��B�"V��N?Ρ���tp�é�����y9\��dW8.�d��\˜Ux��Q�u��w�Z.G;KJ>�o�����q��]l���D����r��-��c�����h���?�������{@������������/?Q�S8�t��'h�u�������o�l�t�&������A���Ͼ��cq��	��8��U@�A����|���ߍи��� a��4��?<��/����,�����f��8�4z�ɭ��-�2��ꡎ���~j��?�'n�w>�t1V�\y���;����/���Y.��q��Ӿ����Q�S�"�j���L-\q�r���i�=����ɽM�%��H[�J��
n=(eO5�kp/M����?��<�4�0�wǩ?�����n����7���N�#i��
�M� �����M��mLš�)���uZ�ѓ`��]�m�7Ӆ��`��G[4S��1����c�]�8��M�?�n���l������O�ߺ�e�oJQC�YdN}��YM�۹�{����Wum���1���a�OޅN �Q
eoi�7�8r�|���fƝ�������	��YGsJ.��>/k�p�"�j�k���	G���x�IVv���x{Y�I����&�ڼ$�|��5\�����C$�
Z�d���&�Uc�=d��nㅧe���2P����Y��踝��Q���X��LY_I6r�J���2[��� u��ӯ6����.�/��k��_#4S��1����c�]�8����?�����c�?����������!��-��<ο�4��������M��'�'���i�����3�O��V��o]��'� ��Z��?��n�s������������O8��]��H8"O)���ሄO9^�)�����x*�qN�_^"و`�,#�'�����_��M��b�������M�of�<�(�ҕ�k�O�B��iU���A�,���p�xy��q%-�U���;�V�VD���l �4����DB�
�ʜ�EJ�[=M�{C�7���ڰ#
Ù����R�f_{�8��t��5���֋�y��KC����L�Dw����μzSm���?IP������C0T�ta�������ڢ;��PmД��h�ŀ�k���'���'���������Z��Ǯ�:��������������g������?	��M�O����1տ9�y9����KS/&� �X�M�ƿ��gn���-
?Q�uR����xb�=�9(�a���0�&Cz���dF�]���!w�F_æꢍ�luJ�1��9�ʧ��z�I�F�s]��L�#�2���.�R,��ľ9�9����z�S������N�ۣ��DȐ�*��SF��2$�|��W��A<�x��z3�1�	����WS9q����W��{~�N%��P\idJ�`&H>����6�>]e����ј\���^͝�z�XT�����,���=g��.#�8��Y���5�!W�w�}>�6G;�D'�?��h���?�j�������p��-:����[���Y�E��o���'����V�h�u�����O"p�ݥ���g�?���o�.�?��ۣ��Y:e<τ82.��MҜR"����;m���X�������@���@BLj��^��__;/y�z��b���AV+�m�}�>��}���HF�S��p��(�f)����IC<�ӘM�r���v�����Z�;����*w�����b3b�{�#����%[]�����ʹs�z��b5��b���ۛbi�f8$I��*&oq؄��eL�񊇪r�L(|�)��z7_$U!{�iV\��(��0w���V�p������������Ȣ��������@���P���?� ��1�����袎��W����(�?�hu���t8��?����C����?�����*��O�q&i�
!�$L�3#��PMEt�q���I��t¥��|#B��������w����.�p��W�#��bݳ�N����&=_!L�X,��z����Ϙ?�gG�_$��X�1o�$Õ��Z��]�ա�exSt6ʱ=�M�7�~ �A���\��6��}�k��n���i�?o
�?�h�����a�p���kH�?���A�����0$������2��: �0�	�0�	�@�5��`�C� ������������ ��l�#�������?��G���@�5��`�C� ������"���!�����������C��?@�}����~% �9�����	������0�C�G� ��o��!��9���Q"����|�\��<B�P)���dń8i���-B����k@��!��9���|���������4ۊX�1f�s�gRx������^�/���5��&ρg�.4���P��6v��;q�
�kN��ք��í8Y�`o8���Ego��0�]�VQ_��Ù;J�ga�o
�?�4�����h(�����������& �?���a��`�� ��_��?��ϭ�����h�������@���������ׁ��\�������`�3d�]�d�ژ.��R����Ř��������lM���P�N-�ښ���n{2����a3�������c4	��>�gR�k�uRu��ֲ=w<�S�2�d�?��{���\4��攬��z4��k<w)�^�F�9���]���K�ąhbc~@��u�z:�$���0���s37ϣ�/��Y��k�& �� ��14�� ��a�����	����ƀ���o(���7��C�������/������G������?�Q��:�������^�Z�ѯ��ܶ���h^�:�����}�������.��������m5��K4z�A]����_���'����Z��oW�e1~W�u���8+��e<����뿳�w�;��|�����R�U���`�Z���b����ߏ|a�2����f؛J��|u��|zs9���;��]���9���9����J�d6��t���æ<�i��޵�)_��x�'^81���[�D1k�q�2^��p ���Kٓrng�������s����˸��e\1E�>v{'��*y ���3�����l_���rd�d�k������$z}�d�}����|���]�x$�%��"��MB-d��H�W��,��|2s���7�B�z��ŅȎ�6��ۭ�E����.�cnj鞦�j﬷�ޒ7�g��z��M�=������.y����[����$�$������`�Q��{����?�����ǻo��';�4[�x�;��9t��������>������Đz_g��'ռ�8Ƥ,z�m�I��I���*���]��|�ϷG�,�|JY��\���HM�b���n^�Ίhc��zBwGg?�]j��W̨Z0+�jh�δ6dQͮ����[�˨�ݖ~�Y_.�-%�W����/��׿�%ɚt�J����3��h&��J�W���K����^fe�Z�T#��i�����2p�dx����K�Z�����þ��=�p���8Zg�DR�Wp�;�r��!f�t��6���l)-��h��k�uXw��Y�{���-�P0�yM[��3�P�ċ7�����_����.y����[������ou���%�ò�2@�@���̓�?	�����K���ۃ�_������zUmC�_llU�"�]Fŗ�W�_��nλ2�Ee�j���8������h��{�\�W��s/������w�Nkr�t�����]�l��#�"jۖ{�7�dj�YѺ���Q���>Ǌ����z�H�>��A�f��d����*�n.}��_�Mz���=�,Z�K���%�W;��4�r�h��Rl`k���^���� �)|�oϾ�ño�L4ԉ���iQa�g�f��<%=c�aR�|?j�͘V��1	q����N'̮���R���������ʚ���I�g��Q���������	��?��	��ԩ����P���i�������Ӭ�{�������)��?4�����'�?
�_�Y�/�����?��:�w2�����+f���o*�=5@�{)�)����e�z�*o�x�t���9�b�J*&򰥴�6�3g��xiy��|v:$q����Պ�����n��&����M;���Fǝ^]�w�W�ݠ8�v�Y���7�v���er���C���g�b�c^뀖��f�c�/�S�F��KF/�[2����&Ʈ�Q��zِ��[�S�3�����f��3؏��!��2�����u�h�?�4�����|��ߓ�O�f@�Ձ�������z�uh�Zf�n�+v�*����O�-������%���7�`}�P4��V�����+w���H�*;��U�9���(�~QW�tN�ⅤSb����Y�q��rT�Ñ���Ց�)/�'��n�2����tv��8=�%;`���^����?{�"u��=���O�؎)��prκ����}�K��S�rl+yërON��B�n&`��9>���,�*e(,�l4��J����$��S2���C������������U�����7������(Xt��v�����T������A�Y�����o'̶EY5q;Tv��E�e���:sG�Ru�e#,�}u��u=Z6a�Fmkݖ0S9hN����l?��~x�o�����Qk�;�,���B����HͶ� �.�3]�p#V[��d���mkkG�8'����ʔr#4uO�xˮc�d���P��l@B�A��14z��_�@A�A��9���������4���  ��>��} �E�����}�� �� ������ׁ����7[��' ��o��I�I�;	�_��"����>���1 ��7��Գ�/��� �O��N� �R"I�X �gSBH6	�و#һ.�yF XR҈�X>NȘ��-?�{�O
�O����0�U�����+���������3U��N���Up�ZV�+B{wq�V?T�)}�<�\�}F�[�t�ɡH�Z�y�ך��=�b]�n���r��OWMSx�nf�h.FX����7�t�E�ؽr�G�x���V���Vf�T���#Z��П�a�~��<|RM�
�?I<��b��������q�p���kH�?����5����͠.�����s������?a�7�����.�����!��4��`1x� �������m��?�_��'o�@@�����_���?����������׌�r�3�䍗�E�V(�9�?����������+�X_��)t�J����Q��/(v��"����*e����V>��sVB��j֘��fi#+K����o�Gg82G���F��TÏۊ�6�\��������<_w����JɾĘ��1%�~����U	�����e�X��Ƿ&���I���D�Q�/{rI���F���{ˎ�Z񀉣�]S�cۭ�+nRZ�ߗiQ�v���s��t.�n�Cy��;ס�J���}�%b�5��WN��,�idkRimG��4�>y 	����Q�����ϭ��������S��p��	�����]������?~�����Q������!Y��u �Op�P��	5����Gu�����w����� �������(�?�~����jA��	#�<����QJ1x"�)����+�aȲ)���G	�4'~�wB�@���.��������A�Ձߙ�a���^��@k���îA��n⾻�*�v�����������_�/���V�p�����������QF�����4~�������=�?A�GM����=�D@����M�?�?���_���~G����M�?�30����$���I>�ٔ�h�b��o�1OKq��ǥ��G�ܨ��:NN��C�
(����w��j����m�	'�ᚬ��Ʋ�Oܾ��(�˽1�9��
��:E���q�$��2�P�X7Ωu��Y�r\טLR�Gs�����دXb��m}�_��PZ�b�ܞ͙�^�NY0l�]2�?o
�?�?�����������h ���_s@���'��0�W��� ������f`�������?��G���a�迚Д���w4 ��s�?$��z�����Z�<���&�������8�� ��`���s��π��ß���o��)���h ����H�?������Z�4���oH���7��C�������n�?T��>+��%�\��	���c��b��r6���������F��w�Y��ۮ�]����U��/U��v4*��.�n�*_G���P��DHyV⒀@D���!A�$��)O�o�v�t��gzFY�Ѵ�s�Su.�����u�Kǋ�,B��Gѭ��F��C^�ʽ���|m�o�����_���=�������;�[�����������w^�����;������s��\�qŶ����Wp<�TDY�b3(�c\B!�!A�����ě� �1�ah��D�r���7�=��2����׏ ����仿e�����ǿ��������x�y��x���@�Ł�aڮ���'������:�I�����T��🿽�;oA/z_�-�'o����I�^�9e��F��B�Pk�)G�t��߭�gpP��4&y���A:7&t8Vh�)t�0��/�Tz���!�)cU/�3�.�:�bJ �g����JyB�/�[q�ɖ��#TQ[u��2di���/c�>���z5�j�NsB7R�Un3%�w����ظ��X��'z��|i7ϩ�`�!�V��T\��9�ULZT�m[z���1�$��1�;�v��%�XHA����F�|,�9�4�
y��(Y��g-��u�4�1��V�hLa�+�t�(�-��N@k����	�K&ޝ]�UR�x\�	QT��J8׃��y�1���2����~�ǦqU�L-�s��;�5�&(2A�4aGs�xkB�p7�+�G�Ԑ�,��'���i�g�Nƌ��t\AG*���Y�`ځB\n:��P	!�4��P�4{dn@FK $��K�H�����Τj
�[g$���,CDg�0��dE�S�&�<�:���a�C�<̷N�u�����C��P�Z�WQpQ6�P�?.
j�U->�$�+D W�q���c͆�ə���C�k?X"��J"�r#Fw�b_&���]�k	-�;��P'���1E�(�.δ�I��D�4�X�m�%�OBy�MrB��y?CF�:C
�:�)ڹ�:q���.��D?��O���X�FP��N8�`Êg�5���%�"�ԅ��=΂,�d������d *��';L3���ͪ��J֡�H,iSO�Y�'�,�,9��/ƉV�Q��=�Κ�d��]�ϖ*�ZQ��`-R�]!��IS@��DU�h�h��,Y�e�A2�d�ܰ�
�7�Wc��1��e�]-*P�a�T!8C+�a�5�S��d��"(�6
��$wr�1��+;Ѩ?�O�L>D�t�M�SfO�Z9�KY��AI;[H�����aU)`x:���'Z1��K�:�����^�ҕ�T�L�5����ړ� ��s�u���9�:@��@g����vF��&�q����&�a�3Κ��6q��s̡���W�1��y����^SҒ�pX�R�� d19Q���J-�*�8m�Y�\#ա�7r/OjF�p:�l�I<��q1���\8}�9�~��U�1�V27Ul��:�*s�V�԰ft2Hբ�i�>��a��L�\�J�b�ʂ�/K�[M��5�6P�Jɀ!����G�٤�@#\W�RuU������T���l�h��L�դl`u���NT�Ԡ1HN��a!߀^�R����{/O���/ �R�Ul��_�a��mx~|~v�3{���.��e�������Ra~mY��!�܄�i�|����1-�<���o�}{w���s��ݓ�˕wv�����T�o��p@���I�l��C,7���7Q��=oʻ���~�h$��:_#Ӊu�U�<fP'�l4*MJ/F\^�zռš�H�uJ��+\_��%��d&T.�>��L����J��Y�M(�d����xs_V�M�����T��Ay�
��>R#��cͳ�{
(�g���=3ϱC�>��N��+uW��Hj��h�׵�v9%8F��J����jUU«����rŢ)�U�n2,���2a���KOb�N+5�uV.2e"R��2!5C=���g{��9���cA�?7�-!ڪ�],���5��(��a�_����d�*�="2@1J�Se�:���B�ņV�ܫ�&�����-�}��v�
����HN5XKb��z�<Lt�J����Z4�z4ĒC�r�Q�.�L�PMC��S!�Ws-+����V4\��d:���4T��59��X�,�&����t����P��6��J=5�Ů
��c@,v����7�m�0d-n�S�]��Tq����"��h�z�%F�ݾw���}���C����������P�{w࿾�Ω��\��l�O[����t���ۗ�KD�Y�B{I����a�C�Q�h�g4�����*E� �XMԯbd�rаX;�C�Nv���>�o��t�������?q	#դ�i���XuKz���܍�8�(�� ��L�R�T�Q�jv�xE��=hD�Y�#��O�mG��n2'>�:�L��nR��ű�xdq��b�H�z#�v��0��u땶)A�FQ1�VW� �+�d�mf�Bɱp8k-!�ԩ,A����L��s<����ϱ�sl��Z?��Z��୵�g�Z��n���{�q���z�F�~:�^i��X߇�����be|~}ղ�Zia�ܼ�4�n\gi��%���MVv\[�	�΂p�KЮ���l8}�[2|~z�15sI�^%Wls�D�߄_ہn}����w>�Y���S^�e���?�}�����;���ݝ=C�<c�f1>K�y�
�b8ށ� $�����.i>�>Oz��VM����G^o9T��[ �۪�"��	��:{6���w }azmJp�yε��۷����S�>�$�B���CH�-;�����{�;�P�Õ萣H x⃱��/a���ߧ5=F��,]1l���X0 >��7����O4r�����o(=���&�T�e���B��<�Q4��"�AI����1\	EQ,����D%L�X����6}�f����� ��k�(���o��~Z�	�d._���-�3y�'9w�ų�W~��t����!>�-{֣�����?������Hzf�o��g��mz>�?x���i�׎��] Hlz  ��We�B�\uv!�l��ь��:����W���G�� K��q�%�\���S��-��T#Tޅ¡b�"��Z+�9tOb�d��싃�m�yY�q����1�� �G�/���G���N�c�Q��{�jlr�K��^�r��±��#��t�w�[Ψ�Ow,Uy���c����������	��j����@�l�rM����빾�>�Ϫ�JK���uupuy��i���,oq��QJUTQp�.^��;6�4xl\7��ظn���9TWj ��fTñq���c㺡���uc���F6׍<6�>xll?xl<�%xl�>|��שmz:ic��D��\(�&� ��ior�K�?h$����o���"�-��Hz�K��j���ӆ�wz���i �j;."۶i�E�^�pA���!9��#�ȁ< U���Dܶ��}�ȋH�-��i�!*����>"J��
<e|@\�>W(�q���W��_�!�o#�P� �֑[A~���;��ԝ`͸o������+�p�����5F,�� �3'O��As�/s�vP�"h�Wһ��ȁu�z�hym�z�[W�?8K��{*5��,���n �n����݅�2�|��]H �����vӀ@H>wl��M�|wg�s7=P���9 =@|}[�!��e[�߯����Mǝ��}��)�W��P{^ɻ��Z�uB���\���W�
�=�_ƛ�S�@,�M	l��
_���ѴE��U���*}K��}Z���{R�~�6�AgϠx��x�c^��4�,���l�%�J���z�)�d�m"��)[�������-8HS��9�I�b�S�^���.�� = �k�!�>h��?p�_�Mݛ���a����/0��l��O?m>����m��t������cxd���I�������W$S�N�m��!ȁ�� ���p�k�ǣ[��U���/�CC3��k�e�	D��?ƶ�#������������W��q3䵾��A�WhM{�	��<�	����В��C,�v��t!<��h��㡃�!м��[m\�b�Yk��\�]Y��Q{
�>+���V�o"=���.µ��TL�צf�v����M��g츲�xb��к�.R7���֪��5Y0@+��@5f��<R���ح-�����O,s�����C�����j�!'�N�����_��cS��������G�������.�M0��@<�����8't��2m�9��-�;�5gjҹr�+�r��lT�4<_��Ҿr�04C�,�V����}������{���>4�7�3�נ��.ug%���Vs0/[�	N-@w�k�/���"M��	�bi�#�|��y:�O��JVa@O�b!����ut��������\��Z%WH&����]�s�(�,'��8M�#r&��Mߧ�����[�QoRΥ�F��6���x�M��S����ˁ�x����.�Q��,��c�uK��N�j�ZS��r�O�ڒ�6r "wM�-$��3�aJ 1�Ļ�,L�����7EG�e>k�}��*�0j�e �T���� ���n$=����|��M�B���o��}��p�"��"��d���ڱ�*�Z)K�D�:�p�NcՍ�4iK%$6� R&��ֱB�,0�#R��wvl'͏&*i)�[�l��{������~�	���,�ŋb���F��&��.��5/�Rz����|��Q ��O���6��*3K��|���_�;�v������u��,��/.HkV�m���~�[�_���EM��hִ���6͞��V=�8��� ���P���겁�?������g.N�M�|	��*Z.�7�"
�C���/Qks��ޅ��		"�1H��P/v�7��3�{��c,�w���G���BX�T6�U;Y� �!�1�8����&"b ����IV!�M�D��5����?�/(+to\�3���xXG3n�1�?/Ȓ,>�z����l�Zi؛\�FJ�bn��VN��]χ��i~��Up��jA���aN�m2뵲We�{�ԯV�����\��lP@}ަW�bN��2�0Æ[��:KD�G��v��B������xX���E��ѧ#���M)�ʍ��U��l������H2�ϘpB���fVѬ����.IX��t0+�s�R�\�a5��\�AϷ�ؓU�J3�U�Vqe�	�I��"��Ò����1�,��~	N��#Z����ߪ���\�񿡰��3dM������{c���<��\�y��Q�����m�[%K׉��d�6��i-K�fN%ٜZ2MQI�$E�D�bN&y[%9=���9>}�`q7�.�?y��?]�����N����a����K�_��q��}�N�Ҝﻰl2�e��HBf����eB����ͼ�^�6�rk|��<M5�(�ؕ�$c�,JR6ْ����&[�M���z^0'��Ƕ�����/�_~y��=�y{u_xx}k�7��L��-�;��@ιot��H�9a�ZNE�
P����FRn�E@]�E�ou0�;fpG�g�F�g�F�gT�AE�F�g�F�g�F�g�F�g�F�g��8�90΁q�5΁�U��q���Va�������Ϩ���Ϩ���Ϩ��@ �@ D ��� � 