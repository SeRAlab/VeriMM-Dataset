module top_module(
    input [2:0] ABC,
    input EN,
    input clk,  // Added clk as an input
    output reg [7:0] Y
);reg [7:0] Y_pipe1;
reg [7:0] Y_pipe2;

always @(ABC, EN) begin
    Y_pipe1 <= {8{1'b0}};
    if (EN == 1'b1) begin
        case (ABC)
            3'b000: Y_pipe1[0] <= 1'b1;
            3'b001: Y_pipe1[1] <= 1'b1;
            3'b010: Y_pipe1[2] <= 1'b1;
            3'b011: Y_pipe1[3] <= 1'b1;
            3'b100: Y_pipe1[4] <= 1'b1;
            3'b101: Y_pipe1[5] <= 1'b1;
            3'b110: Y_pipe1[6] <= 1'b1;
            3'b111: Y_pipe1[7] <= 1'b1;
            default: Y_pipe1 <= {8{1'b0}};
        endcase
    end
end

always @(posedge clk) begin
    Y_pipe2 <= Y_pipe1;
end

assign Y = EN ? Y_pipe2 : {8{1'b0}};

endmodule