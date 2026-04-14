module GPIO_Controller (
    input wire [3:0] GPIO_IN,
    input wire ENABLE,
    input wire RST,
    output reg [3:0] GPIO_OUT
);

always @(posedge RST or posedge ENABLE) begin
    if (RST) begin
        GPIO_OUT <= 4'b0000;
    end else if (ENABLE) begin
        GPIO_OUT <= GPIO_IN;
    end
end

endmodule