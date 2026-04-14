module binary_down_counter(
    input       clk,
    input       rst,
    output reg [3:0] count
);

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b1111;
        end
        else begin
            count <= count - 1'b1;
        end
    end

endmodule