module simple_counter (
    input clk,
    input rst,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 3'd0;
        end else begin
            count <= count + 1;
        end
    end

endmodule