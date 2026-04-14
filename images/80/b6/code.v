module shift_register_4bit (
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 4'b0000;
        else if (load)
            data_out <= data_in;
        else
            data_out <= {data_out[2:0], 1'b0};
    end

endmodule