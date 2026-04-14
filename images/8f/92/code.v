module top_module(
    input clk,
    input reset,
    input [7:0] y,
    input [7:0] cb,
    input [7:0] cr,
    output reg [9:0] r,
    output reg [9:0] g,
    output reg [9:0] b,
    output reg data_valid
);// Internal signals
reg signed [9:0] r_temp;
reg signed [9:0] g_temp;
reg signed [9:0] b_temp;

// Constants
parameter signed [9:0] k1 = 1.402 * 256;
parameter signed [9:0] k2 = 0.34414 * 256;
parameter signed [9:0] k3 = 0.71414 * 256;
parameter signed [9:0] k4 = 1.772 * 256;

always @(posedge clk) begin
    if (reset) begin
        r <= 0;
        g <= 0;
        b <= 0;
        data_valid <= 0;
    end else begin
        r_temp <= y + ((cr - 128) * k1 / 256);
        g_temp <= y - ((cb - 128) * k2 / 256) - ((cr - 128) * k3 / 256);
        b_temp <= y + ((cb - 128) * k4 / 256);
        
        if (r_temp < 0) begin
            r <= 0;
        end else if (r_temp > 1023) begin
            r <= 1023;
        end else begin
            r <= r_temp;
        end
        
        if (g_temp < 0) begin
            g <= 0;
        end else if (g_temp > 1023) begin
            g <= 1023;
        end else begin
            g <= g_temp;
        end
        
        if (b_temp < 0) begin
            b <= 0;
        end else if (b_temp > 1023) begin
            b <= 1023;
        end else begin
            b <= b_temp;
        end
        
        data_valid <= 1;
    end
end

endmodule