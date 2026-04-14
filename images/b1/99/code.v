module top_module(
    input  bclk,
    output out
);reg pulse;
reg [7:0] count = 0;

always @(negedge bclk)
    if (count >= 250) begin
        pulse = 1;
        count = 0;
    end
    else begin
        pulse = 0;
        count = count + 1;
    end

assign out = pulse;

endmodule