module up_down_counter (
    input wire up_down,
    input wire clk,
    output reg [7:0] count
);

    always @(posedge clk) begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule