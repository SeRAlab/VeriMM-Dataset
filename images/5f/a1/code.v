module top_module(
    input valid,
    input [3:0] A,
    input [3:0] B,
    input [1:0] sel,
    output [1:0] out_mode0,
    output less_than,
    output equal_to,
    output greater_than
);reg [1:0] magnitude;
    reg less_than_reg, equal_to_reg, greater_than_reg;
    
    always @(*) begin
        if (A == B) begin
            magnitude = 2'b00;
            less_than_reg = 1'b0;
            equal_to_reg = 1'b1;
            greater_than_reg = 1'b0;
        end else if (A > B) begin
            magnitude = 2'b01;
            less_than_reg = 1'b0;
            equal_to_reg = 1'b0;
            greater_than_reg = 1'b1;
        end else begin
            magnitude = 2'b10;
            less_than_reg = 1'b1;
            equal_to_reg = 1'b0;
            greater_than_reg = 1'b0;
        end
    end
    
    assign out_mode0 = (sel == 2'b00) ? magnitude : 2'b00;
    assign less_than = (sel == 2'b01) ? less_than_reg : 1'b0;
    assign equal_to = (sel == 2'b01) ? equal_to_reg : 1'b0;
    assign greater_than = (sel == 2'b01) ? greater_than_reg : 1'b0;
    
endmodule