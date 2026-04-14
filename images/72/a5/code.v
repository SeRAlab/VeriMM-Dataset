module shift_register(
    input clk,
    input rst,
    input shift,
    input load,
    input [3:0] data_in,
    
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            data_out <= {data_out[2:0], 1'b0};
        end
    end
endmodule