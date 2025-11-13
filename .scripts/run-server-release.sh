tmpdir=$(dirname "$(realpath $0)")
cd $tmpdir/../lib/server
dart run --define=dart.vm.product=true server.dart