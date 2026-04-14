module top_module(
    input clk,
    input rst,
    input [3:0] a,
    input [3:0] b,
    input cin,
    output reg [3:0] sum,
    output reg cout
);wire [3:0] carry;
    
    always @(*) begin
        {cout, sum} = a + b + cin;
    end

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            sum <= 4'b0000;
            cout <= 1'b0;
        end else begin
            // Output is updated based on combinational logic
            // No need to update carry here as it is computed in the always block above
        end
    end

endmodule