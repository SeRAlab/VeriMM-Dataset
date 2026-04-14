module top_module( 
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor 
);// Define internal signals
reg [99:0] bdd_and;
reg [99:0] bdd_or;
reg [99:0] bdd_xor;

// Define intermediate signals
reg [99:0] temp_and;
reg [99:0] temp_or;
reg [99:0] temp_xor;

// Define BDD gates
assign bdd_and = &in;
assign bdd_or = |in;
assign bdd_xor = ^in;

// Define output ports
assign out_and = bdd_and[99];
assign out_or = bdd_or[99];
assign out_xor = bdd_xor[99];

endmodule