module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);// internal signals
reg [3:0] shift_reg;

// reset shift register to all zeros
always @ (negedge reset) begin
    shift_reg <= 4'b0;
end

// shift data on rising edge of clock
always @ (posedge clk) begin
    if (load) begin
        // load data on next rising edge of clock
        shift_reg <= data_in;
    end else begin
        // shift data
        shift_reg <= {shift_reg[2:0], shift_reg[3]};
    end
end

// output data
assign data_out = shift_reg;

endmodule