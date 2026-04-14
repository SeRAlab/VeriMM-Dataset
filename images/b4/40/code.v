module fifo_queue (
    input clk,
    input reset,
    input en,
    input data_in,
    output reg [4:0] queue
);

    always @(posedge clk) begin
        if (reset) begin
            queue <= 5'b0;
        end else if (en) begin
            queue <= {queue[3:0], data_in};
        end
    end

endmodule