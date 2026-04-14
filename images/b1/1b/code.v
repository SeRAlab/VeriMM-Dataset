module top_module(
    input [5:0] Mem_Addr,
    input [1:0] CS,
    input Mem_Write,
    input Clk,
    input [31:0] dina,
    output reg [7:0] LED
);reg [31:0] mem [0:3];
    wire [31:0] F;

    // Assuming RAM_B is to be replaced with a behavioral model.
    always @(posedge Clk) begin
        if (Mem_Write) begin
            case (Mem_Addr[1:0]) // Only need lower 2 bits for a 4-entry memory
                2'b00: mem[0] <= dina;
                2'b01: mem[1] <= dina;
                2'b10: mem[2] <= dina;
                2'b11: mem[3] <= dina;
            endcase
        end
    end

    // Output Logic
    always @ (*) begin
        case (CS)
            2'b00: LED <= mem[0][7:0];
            2'b01: LED <= mem[1][15:8];
            2'b10: LED <= mem[2][23:16];
            2'b11: LED <= mem[3][31:24];
            default: LED <= 8'b0; // Default case to avoid latches
        endcase
    end

    // Removed the unused assign statement for dina
endmodule