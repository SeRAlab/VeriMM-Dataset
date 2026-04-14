module top_module(
    input clk, rst,
    input [14:0] para_in,
    input dir_in,
    output reg dir_out,
    output reg en_out
);parameter MAX = 19999;

reg [14:0] duty_cycle;
reg [14:0] duty_cycle_;
reg dir_;
reg [31:0] counter;
wire [31:0] divflag;
reg [31:0] PWMctl_clk;

initial PWMctl_clk = MAX;
initial duty_cycle = MAX;

assign divflag = PWMctl_clk - duty_cycle;

always @(posedge clk) begin
    if (rst) begin
        duty_cycle <= 0;
        dir_ <= 0;
        counter <= 0;  // Reset counter on reset for better design clarity
    end
    else if (para_in < PWMctl_clk) begin
        duty_cycle <= para_in;
        dir_ <= dir_in;
    end
    else begin
        duty_cycle <= MAX;
    end
end

always @(posedge clk) begin
    if (rst) begin
        en_out <= 0;  // Initialize en_out on reset
    end
    else if (divflag > counter) begin
        en_out <= 1;
    end
    else begin
        en_out <= 0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
    end
    else if (counter == PWMctl_clk) begin
        counter <= 0;  // Correct condition for counter reset
    end
    else begin
        counter <= counter + 1;
    end
end

assign dir_out = dir_;  // moved dir_out assignment to make it clear as comb. logic

endmodule