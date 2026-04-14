module shift_register_8bit(clk, rst, load, data_in, Q);
    input clk, rst, load;
    input [7:0] data_in;
    output reg [7:0] Q;

    always @(posedge clk) begin
        if (rst)
            Q <= 8'b00000000;
        else if (load)
            Q <= data_in;
        else
            Q <= {Q[6:0], 1'b0};
    end
endmodule