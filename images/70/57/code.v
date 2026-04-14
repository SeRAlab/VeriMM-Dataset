module top_module(
    input CLK, RST,
    input UD1, LD1, input [7:0] LOAD_IN1, output reg [7:0] Q1,
    input UD2, LD2, input [7:0] LOAD_IN2, output reg [7:0] Q2,
    output [7:0] sum
);reg [7:0] count1, count2;

always @(posedge CLK) begin
    if (RST) begin
        count1 <= 8'b0;
        count2 <= 8'b0;
    end else begin
        if (UD1) begin
            count1 <= count1 + 1;
        end else begin
            count1 <= count1 - 1;
        end
        
        if (UD2) begin
            count2 <= count2 + 1;
        end else begin
            count2 <= count2 - 1;
        end
        
        if (LD1) begin
            count1 <= LOAD_IN1;
        end
        
        if (LD2) begin
            count2 <= LOAD_IN2;
        end
    end
end

assign sum = count1 + count2;

assign Q1 = count1;
assign Q2 = count2;

endmodule