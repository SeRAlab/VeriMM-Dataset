module bidirectional_shift_register(
    input clk,
    input reset,
    input direction,
    input [3:0] data_in,
    output reg [3:0] data_out
    );
    
    always @(posedge clk) begin
        if (reset)
            data_out <= 4'b0000;
        else if (direction)
            data_out <= {data_out[2:0], data_in[3]};
        else
            data_out <= {data_in[0], data_out[3:1]};
    end
endmodule