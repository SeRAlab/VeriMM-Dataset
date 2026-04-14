module shift_register(
    input                 clk,
    input                 rst,
    input                 serial_in,
    
    output reg [3:0]      parallel_out
);

// Shift register implementation
always @(posedge clk) begin
    if (rst) begin
        parallel_out <= 4'd0;
    end
    else begin
        parallel_out <= {serial_in, parallel_out[3:1]};
    end
end

endmodule