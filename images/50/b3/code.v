module top_module(
    input clk,         // Added clk input
    input A,
    input B,
    input C,
    input D,
    output reg [1:0] Y,
    output reg V
);reg [1:0] Y_pipe1;
reg [1:0] Y_pipe2;
reg V_pipe1;
reg V_pipe2;

always @(posedge clk) begin
    Y_pipe2 <= Y_pipe1;
    Y_pipe1 <= Y;
    V_pipe2 <= V_pipe1;
    V_pipe1 <= V;
    
    if (A) begin
        Y <= 2'b00;
        V <= 1'b1;
    end
    else if (B) begin
        Y <= 2'b01;
        V <= 1'b1;
    end
    else if (C) begin
        Y <= 2'b10;
        V <= 1'b1;
    end
    else if (D) begin
        Y <= 2'b11;
        V <= 1'b1;
    end
    else begin
        Y <= Y_pipe2;
        V <= V_pipe2;
    end
end

endmodule