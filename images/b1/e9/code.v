module odd_parity_generator (
    input clk,
    input reset,
    input [2:0] data,
    output reg parity
);

    always @(posedge clk) begin
        if (reset) begin
            parity <= 1'b0;  // Reset the parity to 0
        end else begin
            parity <= data[0] ^ data[1] ^ data[2];  // Generate odd parity
        end
    end

endmodule