module ring_counter_3bit(
    input wire clk,
    input wire rst,
    output reg [2:0] state
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b001;
    end
    else begin
        state <= {state[1:0], state[2]};
    end
end

endmodule