module JohnsonCounter (
    input clk,
    input reset,
    output reg [4:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 5'b00000;
        else
            count <= {~count[4], count[4:1]};
    end
endmodule