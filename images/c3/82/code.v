module binary_converter(
    input [3:0] binary_in,
    output [1:0] binary_out
);

    wire greater_than_five;
    wire is_odd;
    
    assign greater_than_five = (binary_in >= 5);
    assign is_odd = (binary_in[0] == 1);
    
    assign binary_out[0] = greater_than_five;
    assign binary_out[1] = is_odd;
    
endmodule