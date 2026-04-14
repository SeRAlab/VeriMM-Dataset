module top_module(
    clock,
    si,
    load,
    data,
    so
);input clock, si, load;
input [4:0] data;
output so;

reg [4:0] shift_reg; // Internal state of the shift register

always @(posedge clock) begin
    if(load) begin
        shift_reg <= data;
    end else begin
        shift_reg <= {shift_reg[3:0], si};
    end
end

assign so = shift_reg[4];

endmodule