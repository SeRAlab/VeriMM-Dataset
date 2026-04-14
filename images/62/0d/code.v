module top_module(
    input [7:0] binary,
    output [11:0] bcd
);reg [3:0] digit1;
reg [3:0] digit2;
reg [3:0] digit3;

always @ (binary) begin
    if (binary >= 100) begin
        digit1 = binary / 100;
        digit2 = (binary % 100) / 10;
        digit3 = binary % 10;
    end else if (binary >= 10) begin
        digit1 = 0;
        digit2 = binary / 10;
        digit3 = binary % 10;
    end else begin
        digit1 = 0;
        digit2 = 0;
        digit3 = binary;
    end
end

assign bcd = {digit1, digit2, digit3};

endmodule