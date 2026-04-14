module top_module(
    input [5:0] opcode,
    output reg [1:0] mem_sel      
);always @(*) begin
    case (opcode)
        6'h28: mem_sel <= 2'b01;       
        6'h38: mem_sel <= 2'b00;       
        6'h29: mem_sel <= 2'b10;       
        6'h2b: mem_sel <= 2'b11;       
        6'h24: mem_sel <= 2'b01;       
        6'h25: mem_sel <= 2'b10;       
        6'h23: mem_sel <= 2'b11;       
        6'h20: mem_sel <= 2'b01;       
        default:mem_sel <= 2'b11;
    endcase
end

endmodule