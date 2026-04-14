module ring_counter_5bit(CLK, RESET, COUNT);
input CLK;
input RESET;
output reg [4:0] COUNT;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        COUNT <= 5'b00001;
    end else begin
        COUNT <= {COUNT[3:0], COUNT[4]};
    end
end

endmodule