module sram_cell (
    input [3:0] D,
    output reg [3:0] Q,
    input RE,
    input WE,
    input CLK
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D; // Write operation
        end
    end

    always @(posedge CLK) begin
        if (RE) begin
            Q <= Q; // Read operation (no change to Q)
        end
    end
endmodule