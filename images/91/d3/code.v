module register (
    input clk,
    input reset,
    input load,
    input [7:0] D,
    output reg [7:0] Q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 8'b0;
        end else if (load) begin
            Q <= D;
        end
    end

endmodule