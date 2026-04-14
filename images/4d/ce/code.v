module top_module(
    input Clk,
    input Reset,
    input Enable,
    input signed [3:0] B,
    output signed [7:0] P
);wire [7:0] M;
    wire [7:0] C;

    // Implementing a simple counter module
    reg [7:0] count;

    always @(posedge Clk or posedge Reset) begin
        if (Reset)
            count <= 0;
        else if (Enable)
            count <= count + 1;
    end

    assign C = count;

    // Implementing a simple signed multiplier module
    assign M = C * $signed(B);

    assign P = M;

endmodule