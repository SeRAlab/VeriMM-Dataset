module mux32to1 (
    input [31:0] data_in,  // 32 input lines
    input [4:0] sel,       // 5-bit select line
    output reg out         // output line
);
    always @(*) begin
        out = data_in[sel]; // Select the input based on the sel line
    end
endmodule