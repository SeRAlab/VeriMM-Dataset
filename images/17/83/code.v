module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [2:0] req,
    output reg [1:0] grant
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 2'b00; // No grant on reset
    end else begin
        case (req)
            3'b100: grant <= 2'b00; // R0 granted
            3'b110: grant <= 2'b00; // R0 granted (R1 also requested)
            3'b101: grant <= 2'b00; // R0 granted (R2 also requested)
            3'b011: grant <= 2'b01; // R1 granted
            3'b111: grant <= 2'b01; // R1 granted (R2 also requested)
            3'b001: grant <= 2'b10; // R2 granted
            3'b000: grant <= 2'b00; // No grant
            default: grant <= 2'b00; // Default case (just in case)
        endcase
    end
end

endmodule