module shift_register(
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    input shift_in,
    
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (reset) begin
        data_out <= 8'b00000000;
    end else if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= {data_out[6:0], shift_in};
    end
end

endmodule