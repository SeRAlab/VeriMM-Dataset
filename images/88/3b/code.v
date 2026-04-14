module bidir_shift_register(
    input clk,
    input reset,
    input shift_dir,
    input [7:0] data_in,
    output reg [7:0] data_out
    );
    
    always @(posedge clk) begin
        if (reset)
            data_out <= 8'b00000000;
        else if (shift_dir)
            data_out <= {data_out[6:0], data_in[7]};
        else
            data_out <= {data_in[0], data_out[7:1]};
    end
endmodule