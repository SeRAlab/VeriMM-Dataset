module shift_reg_16bit(clk, reset, load, data_in, shift_in, data_out);
    input clk, reset, load, shift_in;
    input [15:0] data_in;
    output reg [15:0] data_out;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[14:0], shift_in};
        end
    end
endmodule