module top_module(data_in, load, shift, reset, data_out, overflow);input [3:0] data_in;
input load, shift, reset;
output [3:0] data_out;
output overflow;

reg [3:0] shift_reg;
wire msb;

// Load data into shift register
always @ (posedge load) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= data_in;
    end
end

// Shift data in shift register
always @ (posedge shift) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {1'b0, shift_reg[3:1]};
    end
end

// Determine overflow
assign msb = shift_reg[3];
assign overflow = (msb == 1);

// Output data
assign data_out = shift_reg;

endmodule