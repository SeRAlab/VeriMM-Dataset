module shift_register (
    input clk,
    input rst,
    input load,
    input dir,
    input [3:0] data_in,
    input shift_in,
    output reg [3:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 4'd0;
        else if (load)
            data_out <= data_in;
        else if (dir)
            data_out <= {shift_in, data_out[3:1]};
        else
            data_out <= {data_out[2:0], shift_in};
    end
endmodule