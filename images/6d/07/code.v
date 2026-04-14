module top_module(
  input [n-1:0] irq,
  input clear, // Added input for clear signal
  output [m-1:0] ack
);parameter n = 4; // number of interrupt request signals
parameter m = 2; // number of interrupt acknowledge signals

reg [n-1:0] irq_priority; // priority encoder output
reg [m-1:0] ack_signals; // interrupt acknowledge signals

// Priority encoder logic
always @* begin
  casez(irq)
    4'b1000: irq_priority = 4'b1000; // highest priority
    4'b0100: irq_priority = 4'b0100;
    4'b0010: irq_priority = 4'b0010;
    4'b0001: irq_priority = 4'b0001; // lowest priority
    default: irq_priority = 4'b0000; // no interrupt request
  endcase
end

// Interrupt acknowledge signal generation logic
always @* begin
  casez(irq_priority)
    4'b1000: ack_signals = 2'b11; // highest priority
    4'b0100: ack_signals = 2'b10;
    4'b0010: ack_signals = 2'b01;
    4'b0001: ack_signals = 2'b01; // lowest priority
    default: ack_signals = 2'b00; // no interrupt request
  endcase
end

// Connect the priority encoder to the interrupt acknowledge signals
assign ack = ack_signals;

// Clear signal logic
always @(posedge clear) begin
  irq_priority <= 4'b0000;
  ack_signals <= 2'b00;
end

endmodule