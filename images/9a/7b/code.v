module ring_counter_12bit(
    input wire clk,
    input wire rst,
    output reg [11:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 12'b000000000001;
        end else begin
            count <= {count[10:0], count[11]};
        end
    end
endmodule