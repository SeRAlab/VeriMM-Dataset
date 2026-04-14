module register_16bit(
    input clk,
    input load_enable,
    input [15:0] din,
    
    output reg [15:0] dout
);
    always @(posedge clk) begin
        if (load_enable)
            dout <= din;
    end
endmodule