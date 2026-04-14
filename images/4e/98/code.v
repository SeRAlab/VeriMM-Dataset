module top_module(
    input clk,
    input clr_n,
    input on,
    input off,
    input [3:0] power,
    output reg [(LEN-1):0] T
);parameter CYCLE = 5;
parameter LEN = 4;

reg [3:0] count;
reg [3:0] power_count;
reg [LEN-1:0] signal;
reg on_prev;
reg off_prev;

always @(posedge clr_n or negedge clr_n) begin
    if (!clr_n) begin
        count <= 0;
        power_count <= 0;
        signal <= 0;
        on_prev <= 0;
        off_prev <= 0;
    end
end

always @(posedge clk) begin
    if (!clr_n) begin
        count <= 0;
        power_count <= 0;
        signal <= 0;
        on_prev <= 0;
        off_prev <= 0;
    end
    else begin
        if (on && !on_prev) begin
            count <= 0;
            power_count <= 0;
            signal <= 0;
        end
        if (off && !off_prev) begin
            count <= 0;
            power_count <= 0;
            signal <= 0;
        end
        on_prev <= on;
        off_prev <= off;
    end
end

always @(posedge clk) begin
    if (on && !off) begin
        count <= count + 1;
        if (count == CYCLE) begin
            count <= 0;
            signal <= {signal[LEN-2:0], 1'b1}; // Changed to 1'b1 for proper concatenation
        end
    end
    else begin
        count <= 0;
        signal <= 0;
    end
end

always @(posedge clk) begin
    if (power_count == power) begin
        power_count <= 0;
    end
    else begin
        power_count <= power_count + 1;
    end
end

assign T = signal << power;

endmodule