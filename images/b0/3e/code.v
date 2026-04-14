module top_module(
    input [99:0] in,
    output [7:0] out_max,
    output [7:0] out_min,
    output [7:0] out_avg
);wire [49:0] max_vals;
wire [49:0] min_vals;

// 50 2-input comparators to compare input values in pairs
genvar i;
generate
    for (i = 0; i < 50; i = i + 1) begin : comp
        assign max_vals[i] = (in[i*2] > in[i*2+1]) ? in[i*2] : in[i*2+1];
        assign min_vals[i] = (in[i*2] < in[i*2+1]) ? in[i*2] : in[i*2+1];
    end
endgenerate

// 50 2-input multiplexers to select larger and smaller values
wire [49:0] max_mux_out;
wire [49:0] min_mux_out;
genvar j;
generate
    for (j = 0; j < 50; j = j + 1) begin : mux
        assign max_mux_out[j] = (max_vals[j] == in[j*2]) ? in[j*2] : in[j*2+1];
        assign min_mux_out[j] = (min_vals[j] == in[j*2]) ? in[j*2] : in[j*2+1];
    end
endgenerate

// Two adders to calculate sum of all input values
wire [7:0] sum;
wire [7:0] avg;
genvar k;
generate
    for (k = 0; k < 50; k = k + 1) begin : adder
        assign sum = sum + max_mux_out[k] + min_mux_out[k];
    end
endgenerate

// Output maximum, minimum, and average values
assign out_max = sum;
assign out_min = sum;
assign out_avg = sum / 100;

endmodule