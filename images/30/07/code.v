module mux32to1 (
    input wire [31:0] data_in,  // 32 input data lines
    input wire [4:0] select,     // 5-bit select line
    output wire data_out         // 1 output line
);
    assign data_out = data_in[select]; // Select the input based on the select line
endmodule