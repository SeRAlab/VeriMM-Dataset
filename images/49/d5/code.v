module sync_ring_counter_10bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [9:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 10'b0000000001;
        end else if (en) begin
            count <= {count[8:0], count[9]};
        end
    end

endmodule