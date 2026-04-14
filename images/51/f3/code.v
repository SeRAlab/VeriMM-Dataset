module binary_up_down_counter(
    input       clk,
    input       rst,
    input       up_down,
    output reg [6:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 7'b0000000;
        end
        else if (up_down) begin
            count <= count + 1'b1;
        end
        else begin
            count <= count - 1'b1;
        end
    end

endmodule