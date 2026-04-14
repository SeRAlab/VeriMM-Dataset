module top_module(
    input CLK,
    input UP,
    input DOWN,
    input SHIFT,
    input RST,
    input [3:0] B,
    output reg [3:0] Q,
    output reg [3:0] RESULT
);reg [3:0] counter;

always @(posedge CLK) begin
    if (RST) begin
        counter <= 4'b0;
        RESULT <= 4'b0;
    end else if (UP && !DOWN) begin
        counter <= counter + 4'b1;
    end else if (!UP && DOWN) begin
        counter <= counter - 4'b1;
    end else begin
        counter <= counter;
    end
    
    if (SHIFT) begin
        RESULT <= counter << B;
    end else begin
        RESULT <= counter;
    end
end

assign Q = counter;

endmodule