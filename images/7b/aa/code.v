module top_module(
    input [3:0] binary_in,
    input clk,
    output reg [3:0] bcd_out,
    output reg EN1,
    output reg EN2,
    output reg EN3
);reg [3:0] bcd_temp;
reg [2:0] count;

always @(posedge clk) begin
    if(count == 0) begin
        bcd_temp = binary_in;
        EN1 = 1;
        EN2 = 0;
        EN3 = 0;
    end
    else if(count == 1) begin
        bcd_temp = bcd_temp + (bcd_temp >= 5);
        EN1 = 0;
        EN2 = 1;
        EN3 = 0;
    end
    else if(count == 2) begin
        bcd_temp = bcd_temp + (bcd_temp >= 10);
        EN1 = 0;
        EN2 = 0;
        EN3 = 1;
    end
    else if(count == 3) begin
        bcd_temp = bcd_temp + (bcd_temp >= 10);
        bcd_out = bcd_temp;
        EN1 = 0;
        EN2 = 0;
        EN3 = 0;
        count <= 0;
    end
    count <= count + 1;
end

endmodule