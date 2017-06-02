unit module AI::FANN::Raw;

use NativeCall;

sub fannlib { 'libfann.so' } 

constant float = num32;
constant fann_type = num32;
constant fann_activationfunc = int32;
constant fann_nettype = int32;

enum fann_nettype_enum is export « :FANN_NETTYPE_LAYER(0) FANN_NETTYPE_SHORTCUT »;
enum fann_activationfunc_enum is export «
    :FANN_LINEAR(0) FANN_THRESHOLD FANN_THRESHOLD_SYMMETRIC
    FANN_SIGMOID FANN_SIGMOID_STEPWISE FANN_SIGMOID_SYMMETRIC FANN_SIGMOID_SYMMETRIC_STEPWISE
    FANN_GAUSSIAN FANN_GAUSSIAN_SYMMETRIC FANN_GAUSSIAN_STEPWISE
    FANN_ELLIOT FANN_ELLIOT_SYMMETRIC
    FANN_LINEAR_PIECE FANN_LINEAR_PIECE_SYMMETRIC
    FANN_SIN_SYMMETRIC FANN_COS_SYMMETRIC
    FANN_SIN FANN_COS
»;


class fann is repr('CPointer') is export {*}
class fann_train_data is repr('CPointer') is export {*}
class fann_connection is repr('CPointer') is export {*}

## http://leenissen.dk/fann/html/files/fann-h.html
## FANN Creation/Execution

#sub fann_create_standard(uint8 $num_layers, ...) returns fann is export is native(&fannlib) {*}
sub fann_create_standard(uint8 $num_layers, *@neurons) returns fann is export {
    my CArray[uint32] $layers = CArray[uint32].new(@neurons);
    return fann_create_standard_array($num_layers, $layers);
}

sub fann_create_standard_array(uint8 $num_layers, CArray[int32] $layers is rw ) returns fann is export is native(&fannlib) {*}

sub fann_set_activation_function_hidden(fann,fann_activationfunc) is export is native(&fannlib) {*}
sub fann_set_activation_function_output(fann,fann_activationfunc) is export is native(&fannlib) {*}
sub fann_train_onfile(fann,fann_activationfunc) is export is native(&fannlib) {*}


sub fann_create_sparse(float $connection_rate, uint8 $num_layers, *@neurons) returns fann is export {
    my CArray[uint32] $layers = CArray[uint32].new(@neurons);
    return fann_create_sparse_array($connection_rate, $num_layers, $layers);
}
sub fann_create_sparse_array(float $connection_rate, uint8 $num_layers, CArray[int32] $layers is rw ) returns fann is export is native(&fannlib) {*}
sub fann_create_shortcut(uint8 $num_layers, *@neurons) returns fann is export {
    my CArray[uint32] $layers = CArray[uint32].new(@neurons);
    return fann_create_shortcut_array($num_layers, $layers);
}
sub fann_create_shortcut_array(uint8 $num_layers, CArray[int32] $layers is rw ) returns fann is export is native(&fannlib) {*}
sub fann_destroy(fann) is export is native(&fannlib) {*}
sub fann_copy(fann) returns fann is export is native(&fannlib) {*}
sub fann_run(fann, float is rw) returns fann is export is native(&fannlib) {*}
sub fann_randomize_weights(fann, float, float) is export is native(&fannlib) {*}
sub fann_init_weights(fann, fann_train_data) is export is native(&fannlib) {*}

sub fann_print_connections(fann) is export is native(&fannlib) {*}
sub fann_print_parameters(fann) is export is native(&fannlib) {*}

sub fann_get_num_input(fann) returns uint32 is export is native(&fannlib) {*}
sub fann_get_num_output(fann) returns uint32 is export is native(&fannlib) {*}
sub fann_get_total_neurons(fann) returns uint32 is export is native(&fannlib) {*}
sub fann_get_total_connections(fann) returns uint32 is export is native(&fannlib) {*}
sub fann_get_network_type(fann) returns uint8 is export is native(&fannlib) {*}
sub fann_get_connection_rate(fann) returns float is export is native(&fannlib) {*}
sub fann_get_num_layers(fann) returns uint32 is export is native(&fannlib) {*}
sub fann_get_layer_array(fann, uint32 is rw) is export is native(&fannlib) {*}
sub fann_get_bias_array(fann, uint32 is rw) is export is native(&fannlib) {*}
sub fann_get_connection_array(fann, fann_connection is rw) is export is native(&fannlib) {*}

sub fann_set_weight_array(fann, fann_connection, uint32) is export is native(&fannlib) {*}
sub fann_set_weight(fann, uint32, uint32, float) is export is native(&fannlib) {*}
sub fann_get_user_data(fann) returns Pointer[void]is export is native(&fannlib) {*}

# not found in my version of FANN
#sub fann_get_decimal_point(fann) returns uint32 is export is native(&fannlib) {*}
#sub fann_get_multiplier(fann) returns uint32 is export is native(&fannlib) {*}

## http://leenissen.dk/fann/html/files/fann_train-h.html
## FANN Training

sub fann_train(fann, fann_type is rw, fann_type is rw) is export is native(&fannlib) {*}
sub fann_test(fann, fann_type is rw, fann_type is rw) is export is native(&fannlib) {*}
sub fann_get_MSE(fann) returns float is export is native(&fannlib) {*}
sub fann_get_bit_fail(fann) returns uint32 is export is native(&fannlib) {*}
sub fann_reset_MSE(fann) is export is native(&fannlib) {*}

sub fann_train_on_data(fann, fann_train_data, uint32, uint32, float) is export is native(&fannlib) {*}
sub fann_train_on_file(fann, Str, uint32, uint32, float) is export is native(&fannlib) {*}
sub fann_train_epoch(fann, fann_train_data) is export is native(&fannlib) {*}
sub fann_test_data(fann, fann_train_data) is export is native(&fannlib) {*}

## Training Data Manipulation

sub fann_read_train_from_file(Str) returns fann_train_data is export is native(&fannlib) {*}
sub fann_create_train(uint32, uint32, uint32) returns fann_train_data is export is native(&fannlib) {*}
sub fann_train_data(uint32, uint32, uint32, & (uint32, uint32,uint32,fann_type)) returns fann_train_data is export is native(&fannlib) {*}

# sub fann_destroy_train(fann_train_data) is export is native(&fannlib) {*}
sub fann_shuffle_train_data(fann_train_data) is export is native(&fannlib) {*}
sub fann_scale_train(fann,fann_train_data) is export is native(&fannlib) {*}
sub fann_descale_train(fann,fann_train_data) is export is native(&fannlib) {*}
sub fann_set_input_scaling_params(fann, fann_train_data, float, float) returns int32 is export is native(&fannlib) {*}
sub fann_set_output_scaling_params(fann, fann_train_data, float, float) returns int32 is export is native(&fannlib) {*}
sub fann_set_scaling_params(fann, fann_train_data, float, float, float, float) returns int32 is export is native(&fannlib) {*}
sub fann_clear_scaling_params(fann) returns int32 is export is native(&fannlib) {*}

sub fann_scale_input(fann, fann_type is rw) is export is native(&fannlib) {*}
sub fann_scale_output(fann, fann_type is rw) is export is native(&fannlib) {*}
sub fann_descale_input(fann, fann_type is rw) is export is native(&fannlib) {*}
sub fann_descale_output(fann, fann_type is rw) is export is native(&fannlib) {*}
sub fann_scale_input_train_data(fann_train_data, fann_type, fann_type is rw) is export is native(&fannlib) {*}
sub fann_scale_output_train_data(fann_train_data, fann_type, fann_type is rw) is export is native(&fannlib) {*}
sub fann_scale_train_data(fann_train_data, fann_type, fann_type is rw) is export is native(&fannlib) {*}
sub fann_merge_train_data(fann_train_data, fann_train_data) is export is native(&fannlib) {*}
sub fann_duplicate_train_data(fann_train_data) returns fann_train_data is export is native(&fannlib) {*}
sub fann_subset_train_data(fann_train_data, uint32, uint32) returns fann_train_data is export is native(&fannlib) {*}
sub fann_length_train_data(fann_train_data) returns uint32 is export is native(&fannlib) {*}
sub fann_num_input_train_data(fann_train_data) returns uint32 is export is native(&fannlib) {*}
sub fann_num_output_train_data(fann_train_data) returns uint32 is export is native(&fannlib) {*}
sub fann_save_train(fann_train_data, Str) returns uint32 is export is native(&fannlib) {*}

sub fann_save(fann, Str) returns uint32 is export is native(&fannlib) {*}
