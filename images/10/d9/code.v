module shift_register (
    input wire [15:0] data_in,
    input wire clk,
    input wire load,
    input wire shift,
    output reg [15:0] data_out
);
    
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            data_out <= {1'b0, data_out[15:1]}; // Shift right with zero fill
        end
    end
endmodule