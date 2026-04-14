module lfsr_5bit(
    input               clk     ,   
    input               rst     ,
    input               en      ,
    output  reg [4:0]   lfsr_out
);

wire feedback;

assign feedback = lfsr_out[4] ^ lfsr_out[2];

always @(posedge clk) begin
    if (rst)
        lfsr_out <= 5'b00001;
    else if (en)
        lfsr_out <= {lfsr_out[3:0], feedback};
end

endmodule