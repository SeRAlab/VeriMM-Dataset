module shift_register (
    input wire clk,
    input wire rst,
    input wire data_in,
    input wire shift_en,
    output reg [3:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) 
            data_out <= 4'b0000;
        else if (shift_en)
            data_out <= {data_out[2:0], data_in};
    end

endmodule