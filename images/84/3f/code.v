module shift_register (
    input clk,
    input rst,
    input en,
    input data_in,
    output reg [7:0] q);
    
    always @(posedge clk) begin
        if (rst)
            q <= 8'b00000000;
        else if (en)
            q <= {q[6:0], data_in};
    end
    
endmodule