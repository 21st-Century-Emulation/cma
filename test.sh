docker build -q -t $1 .
docker run --rm --name cma -d -p 8080:8080 $1

RESULT=`curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"opcode":0,"state":{"a":181,"b":0,"c":0,"d":0,"e":0,"h":0,"l":0,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":false},"programCounter":0,"stackPointer":0,"cycles":0}}' \
  http://localhost:8080/api/v1/execute`
EXPECTED='{"opcode":0,"state":{"a":74,"b":0,"c":0,"d":0,"e":0,"h":0,"l":0,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":false},"programCounter":0,"stackPointer":0,"cycles":4}}'

docker kill cma

DIFF=`diff <(jq -S . <<< "$RESULT") <(jq -S . <<< "$EXPECTED")`

if [ $? -eq 0 ]; then
    echo -e "\e[32mCMA Test Pass \e[0m"
    exit 0
else
    echo -e "\e[31mCMA Test Fail  \e[0m"
    echo "$RESULT"
    echo "$DIFF"
    exit -1
fi