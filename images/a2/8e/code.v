module ring_counter(
    input clk,
    input reset,
    output reg [3:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b1000;
        end else begin
            count <= {count[0], count[3:1]};
        end
    end
endmodule