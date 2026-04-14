module PIPO_Shift_Register (
    input wire clk,
    input wire load,
    input wire [4:0] D,
    output reg [4:0] Q
);
    always @(posedge clk) begin
        if (load) begin
            Q <= D; // Load data on load signal
        end else begin
            Q <= {Q[3:0], 1'b0}; // Shift left
        end
    end
endmodule