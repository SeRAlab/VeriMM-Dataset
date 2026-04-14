module mux32to1(
    input wire [31:0] data,  // 32-bit input
    input wire [4:0] sel,    // 5-bit select
    output wire out          // single output
);
    assign out = data[sel];   // Select the corresponding bit based on sel
endmodule