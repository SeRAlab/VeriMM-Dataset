module top_module(out, in, scanen, sin, clock, reset);output out ;
input in ;
input clock ;
input sin ;
input scanen ;
input reset;

wire reset_nor;
assign reset_nor = ~(reset & ~clock);

reg dff_out; // Use a reg to store the state

always @(posedge clock or posedge reset) begin
    if (reset) begin
        dff_out <= 1'b0; // Reset the flip-flop
    end else begin
        if (scanen) begin
            dff_out <= sin; // Scan input taken
        end else begin
            dff_out <= in; // Regular input taken
        end
    end
end

assign out = dff_out; // Output the state of the flip-flop

endmodule