module top_module(
    input CLK,
    input CLR,
    input LD,
    input [3:0] DATA,
    output reg [7:0] Q, // 8-bit output from the functional module
    output reg [3:0] Q0,
    output reg [3:0] Q1,
    output reg [3:0] Q2,
    output reg [3:0] Q3,
    output reg [3:0] Q4,
    output reg [3:0] Q5,
    output reg [3:0] Q6,
    output reg [3:0] Q7
);reg [3:0] counter1;
reg [3:0] counter2;
reg [7:0] sum;

always @(posedge CLK) begin
    if (CLR) begin
        counter1 <= 4'b0;
        counter2 <= 4'b0;
        sum <= 8'b0;
    end else if (LD) begin
        counter2 <= DATA;
    end else begin
        counter1 <= counter1 + 1;
        counter2 <= counter2 + 1;
        sum <= counter1 + counter2;
    end
end

assign Q0 = counter1[0];
assign Q1 = counter1[1];
assign Q2 = counter1[2];
assign Q3 = counter1[3];
assign Q4 = counter2[0];
assign Q5 = counter2[1];
assign Q6 = counter2[2];
assign Q7 = counter2[3];

always @(posedge CLK) begin
    if (CLR) begin
        Q <= 8'b0;
    end else begin
        Q <= sum;
    end
end

endmodule