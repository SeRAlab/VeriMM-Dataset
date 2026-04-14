module MAC (
    input clk, 
    input sof, 
    input [15:0] A, 
    input [15:0] B, 
    output reg [35:0] C
);

reg [31:0] acc; // accumulator for the MAC operation

always @(posedge clk) begin
    if (sof) begin // start of frame
        acc <= A * B; // perform MAC operation
        C <= {acc, 4'b0}; // store result in C
    end else begin
        acc <= acc + A * B; // accumulate result
    end
end

endmodule