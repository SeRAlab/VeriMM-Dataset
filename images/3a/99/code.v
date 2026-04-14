module pipo_shift_register (
    input clk,
    input rst,
    input load,
    input [7:0] data_in,
    input shift,
    output reg [7:0] data_out
);
  
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            data_out <= data_out; // Hold the current state
        end
    end

endmodule