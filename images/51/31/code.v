module top_module(
    input clk,
    input reset,
    input load,
    input direction,
    input [N-1:0] data_in,
    output [N-1:0] data_out
);parameter N = 8; // number of bits in the shift register

reg [N-1:0] reg_data;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        reg_data <= 0;
    end else if (load) begin
        reg_data <= data_in;
    end else begin
        if (direction) begin
            reg_data <= {reg_data[N-2:0], reg_data[N-1]};  // Shift left
        end else begin
            reg_data <= {reg_data[0], reg_data[N-1:1]};    // Shift right
        end
    end
end

assign data_out = reg_data;

endmodule