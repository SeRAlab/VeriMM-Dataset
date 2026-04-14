module shift_register(
    input                 clk,
    input                 rst_n,
    input                 load,
    input       [7:0]     data_in,
    
    output reg  [7:0]     data_out
);

// Shift register implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 8'd0;
    else if (load)
        data_out <= data_in;
    else
        data_out <= {1'b0, data_out[7:1]};
end

endmodule