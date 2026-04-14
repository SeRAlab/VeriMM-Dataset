module johnson_counter (
    input clk,
    input reset,
    output reg [1:0] count
);

    // Johnson counter logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 2'b00;
        else
            count <= {~count[0], count[1]};
    end

endmodule