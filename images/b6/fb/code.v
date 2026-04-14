module shift_register_4bit(
    input clk, reset, load, shift_in,
    input [3:0] data_in,
    output reg [3:0] data_out);
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 4'b0;
        else if (load)
            data_out <= data_in;
        else
            data_out <= {data_out[2:0], shift_in};
    end
endmodule