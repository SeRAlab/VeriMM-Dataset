module shift_register_8bit(clk, reset, load, data_in, shift, data_out);
    input clk;
    input reset;
    input load;
    input [7:0] data_in;
    input shift;
    output reg [7:0] data_out;

    always @(posedge clk) begin
        if (reset)
            data_out <= 8'b00000000;
        else if (load)
            data_out <= data_in;
        else if (shift)
            data_out <= {1'b0, data_out[7:1]};
    end
endmodule