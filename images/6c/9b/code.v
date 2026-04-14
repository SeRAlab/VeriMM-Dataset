module shift_register_4bit(
    input clk,
    input rst,
    input serial_in,
    
    output reg [3:0] parallel_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) 
            parallel_out <= 4'b0000;
        else 
            parallel_out <= {parallel_out[2:0], serial_in};
    end
endmodule