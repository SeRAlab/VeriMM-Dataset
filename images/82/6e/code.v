module johnson_counter(
    input clk,
    input reset,
    output reg [7:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 8'd0;
        else
            count <= {~count[0], count[7:1]};
    end
endmodule