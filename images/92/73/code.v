module top_module(
    input [3:0] A,
    input [3:0] B,
    output greater_than,
    output less_than,
    output equal_to,
    output valid
);reg [1:0] result;
    
    always @* begin
        if (A > B) begin
            result = 2'b01;
        end
        else if (A < B) begin
            result = 2'b10;
        end
        else begin
            result = 2'b00;
        end
    end
    
    assign greater_than = (result == 2'b01);
    assign less_than = (result == 2'b10);
    assign equal_to = (result == 2'b00);
    assign valid = (result != 2'b11);
    
endmodule