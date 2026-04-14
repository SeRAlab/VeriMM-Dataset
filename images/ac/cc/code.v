module top_module(
    input CLK,
    input RST,
    input ENA,
    input [7:0] RGA,
    input [0:0] RGB,
    input [7:0] OPT,
    input [1:0] KEY,
    output [7:0] RGZ
);reg [7:0] shift_reg;
reg [7:0] not_reg;
reg [7:0] zero_reg;

always @ (posedge CLK) begin
    if (RST) begin
        shift_reg <= 8'b0;
        not_reg <= 8'b0;
        zero_reg <= 8'b0;
    end else begin
        if (ENA) begin
            case ({OPT[3:0], KEY})  // Adjusted to ensure only the necessary bits of OPT are used
                12'b000000010000: shift_reg <= {RGA[6:0], 1'b0};   // Corrected size
                12'b000000000000: shift_reg <= {1'b0, RGA[7:1]};   // Corrected size
                12'b000000010100: shift_reg <= {RGA[5:0], 2'b00};   // Corrected size
                12'b000000000100: shift_reg <= {2'b00, RGA[7:2]};   // Corrected size
                12'b000000011000: not_reg <= ~RGA;                   // Corrected size
                12'b000000001000: zero_reg <= 8'b0;                  // Corrected size
                default: shift_reg <= RGA;                             // Corrected size
            endcase
        end
    end
end

assign RGZ = RGB ? not_reg : (KEY == 2'b10 ? zero_reg : shift_reg);

endmodule