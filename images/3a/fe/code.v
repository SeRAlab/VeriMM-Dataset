module even_parity_generator #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] data_in,
    output wire parity_out
);
    assign parity_out = ~(^data_in); // Even parity calculation
endmodule