module top_module(
    input clk, // clock signal
    input reset, // reset signal
    output reg [2:0] count // output count
);always @(posedge clk) begin
        if (reset) begin // reset counter to 0
            count <= 3'b0;
        end else begin // increment counter
            count <= count + 1;
        end
    end

endmodule