module top_module(
    input wire a, b, c, // Inputs to the multiplexer
    input wire [15:0] in, // Input to the splitter
    output wire [7:0] out_hi, // Upper byte of the splitter output
    output wire [7:0] out_lo, // Lower byte of the splitter output
    output wire [23:0] final_out // Final 24-bit output from the functional module
);// Multiplexer
wire w, x, y, z;
assign w = a;
assign x = b;
assign y = b;
assign z = c;

// Splitter
wire [7:0] in_hi, in_lo;
assign in_hi = in[15:8];
assign in_lo = in[7:0];

// Functional module
wire [23:0] sum;
assign sum = {8'b0, w} + {8'b0, x} + {8'b0, y} + {8'b0, z} + {8'b0, in_hi} + {8'b0, in_lo};

// Output assignments
assign out_hi = in_hi;
assign out_lo = in_lo;
assign final_out = sum;

endmodule