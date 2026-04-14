module mux2to1 (
    input wire [7:0] data0, // First input
    input wire [7:0] data1, // Second input
    input wire sel,         // Select line
    output wire [7:0] out   // Output
);
    wire [7:0] forward_data;

    assign forward_data = (out == data0) ? data0 : (sel ? data1 : data0);
    assign out = (sel) ? data1 : data0;

endmodule