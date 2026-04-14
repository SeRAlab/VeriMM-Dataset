module top_module(
    input  [31:0] add_port_a,
    input  [31:0] add_port_b,
    output [31:0] add_result
    );assign add_result = (add_port_a + add_port_b); 
endmodule