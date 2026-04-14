module top_module( 
    input clk,              // Add clk input
    input [254:0] in,
    output [7:0] out 
);reg [254:0] shift_reg;
reg [7:0] count;
wire comparator_out;      // Change comparator_out to wire since we are comparing

// Shift register
always @(posedge clk) begin
    shift_reg <= {shift_reg[253:0], in}; // Shift in data
end

// Comparator
assign comparator_out = (shift_reg[254:247] == 8'b11111111); // Optimize comparison

// Counter
always @(posedge clk) begin
    if (comparator_out) begin
        count <= count + 1;
    end
end

// Output
assign out = count;

endmodule