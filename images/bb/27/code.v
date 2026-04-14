module johnson_counter (
    input clk,
    output reg [4:0] count
);

    always @(posedge clk) begin
        count <= {count[3:0], ~count[4]};
    end

endmodule