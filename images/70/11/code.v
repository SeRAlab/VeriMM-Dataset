module top_module(
    input A2,
    input A1,
    input A0,
    output reg EN,  // Changed to reg type
    output reg [2:0] Y
);always @(*) begin
    case ({A2, A1, A0})
        3'b000: begin
            EN = 0;
            Y = 3'b000;
        end
        3'b001: begin
            EN = 1;
            Y = 3'b001;
        end
        3'b010: begin
            EN = 1;
            Y = 3'b010;
        end
        3'b011: begin
            EN = 1;
            Y = 3'b011;
        end
        3'b100: begin
            EN = 1;
            Y = 3'b100;
        end
        3'b101: begin
            EN = 1;
            Y = 3'b101;
        end
        3'b110: begin
            EN = 1;
            Y = 3'b110;
        end
        3'b111: begin
            EN = 1;
            Y = 3'b111;
        end
        default: begin  // Add default case for safety
            EN = 0;
            Y = 3'b000;
        end
    endcase
end

endmodule