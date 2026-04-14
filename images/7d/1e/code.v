module top_module(
    input clk,
    input rst,
    input clk0,
    input clk1,
    input clk2,
    input counter_we,
    input [31:0] counter_val,
    input [1:0] counter_ch,
    output reg counter0_OUT,
    output reg counter1_OUT,
    output reg counter2_OUT,
    output reg [31:0] counter_out
);reg [31:0] counter0;
reg [31:0] counter1;
reg [31:0] counter2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter0 <= 0;
        counter1 <= 0;
        counter2 <= 0;
    end else begin
        counter0 <= counter0 + 1;
        counter1 <= counter1 + 1;
        counter2 <= counter2 + 1;
    end
end

always @(posedge clk0) begin
    if (counter_we && counter_ch == 2'b00) begin
        counter0 <= counter_val;
    end
    counter0_OUT <= counter0[0];
end

always @(posedge clk1) begin
    if (counter_we && counter_ch == 2'b01) begin
        counter1 <= counter_val;
    end
    counter1_OUT <= counter1[0];
end

always @(posedge clk2) begin
    if (counter_we && counter_ch == 2'b10) begin
        counter2 <= counter_val;
    end
    counter2_OUT <= counter2[0];
end

always @(*) begin
    case (counter_ch)
        2'b00: counter_out = counter0;
        2'b01: counter_out = counter1;
        2'b10: counter_out = counter2;
        2'b11: counter_out = counter0 + counter1 + counter2;
    endcase
end

endmodule