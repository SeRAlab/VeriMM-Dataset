module top_module(
    input clk,
    input d,
    input reset,
    input [1:0] select,
    output reg [1:0] LED
);reg [1:0] ff1, ff2;
    
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            ff1 <= 2'b0;
            ff2 <= 2'b0;
        end else begin
            ff1 <= d;
            ff2 <= ff1;
        end
    end
    
    always @(*) begin
        case (select)
            2'b00: LED <= ff1;
            2'b01: LED <= ff2;
            2'b10: LED <= 2'b0;
            2'b11: LED <= 2'b1;
        endcase
    end
    
endmodule