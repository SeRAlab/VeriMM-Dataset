module top_module(
    input clk,
    input reset,    // Synchronous active-high reset
    input load,
    input ena,
    input [3:0] data_in,
    input select,   // Select input to choose between Johnson counter and shift register
    output reg [3:0] q  // 4-bit output from the active module
);reg [5:0] johnson_counter = 6'b000000;

always @(posedge clk) begin
    if (reset) begin
        johnson_counter <= 6'b000000;
        q <= 4'b0000;
    end else begin
        if (select) begin
            // Shift register is active
            if (load) begin
                q <= data_in;
            end else if (ena) begin
                q <= {q[2:0], 1'b0};
            end
        end else begin
            // Johnson counter is active
            johnson_counter <= {johnson_counter[3:0], ~johnson_counter[5], johnson_counter[4]};
            q <= johnson_counter[5:2];
        end
    end
end

endmodule