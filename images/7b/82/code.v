module top_module(
    input clk,
    input reset,
    input up_down,
    output reg [3:0] out
);reg [2:0] count;
reg parity;

always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
        count <= 0;
        parity <= 0;
    end else begin
        if (up_down == 1) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
        
        parity <= ~parity;
    end
end

assign out = {parity, count};

endmodule