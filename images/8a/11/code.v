module top_module(
    output reg Q,        // Change to 'reg' type for storage
    input D,
    input CLK,
    input SET,
    input NOTIFIER,
    input VPWR,
    input VGND
);always @ (posedge CLK or negedge SET) begin
    if (!SET) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

// Properly declare NOTIFIER as a wire
assign NOTIFIER = (Q != D);

endmodule