module johnson_counter (
    input clk,
    input reset,
    output reg [1:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 2'b10;
        else
            count <= {count[0], ~count[1]};
    end

endmodule