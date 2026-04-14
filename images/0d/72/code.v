module shift_register (
    input clk,
    input load,
    input shift,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            data_out <= {1'b0, data_out[3:1]}; // Shift right with zero fill
        end
    end

endmodule