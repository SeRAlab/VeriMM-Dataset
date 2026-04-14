module top_module(
    input clk,
    input rst,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 3'b001;
        else
            count <= {count[1:0], count[2]};
    end

endmodule