module DAC_Controller (
    input [23:0] din,
    output reg dout
);
    always @(*) begin
        if (din > 24'h800000) 
            dout = 1'b1;
        else 
            dout = 1'b0;
    end
endmodule