module top_module(
    input [2:0] In, 
    output reg [7:0] Out 
);always @ (In)
begin
    case (In)
        3'b000:
            Out = 8'd1;
        3'b001:
            Out = 8'd2;
        3'b010:
            Out = 8'd4;
        3'b011:
            Out = 8'd8;
        3'b100:
            Out = 8'd16;
        3'b101:
            Out = 8'd32;
        3'b110:
            Out = 8'd64;
        3'b111:
            Out = 8'd128;
        default:
            Out = 8'd0;
    endcase
end
endmodule