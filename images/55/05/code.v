module top_module(input clk, reset, data, output reg [2:0] q);// Change reg q to reg [2:0] q

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b0;
        end else begin
            q <= {q[1:0], data}; // Shift operation is now valid
        end
    end

endmodule