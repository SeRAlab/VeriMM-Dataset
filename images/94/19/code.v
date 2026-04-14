module top_module(
  input [n-1:0] irq,
  input clk,               // Added clock input
  input reset,             // Added reset input
  output reg [n-1:0] ack   // Changed ack to reg type
);parameter n = 4; // number of interrupt requests

reg [n-1:0] irq_priority;
reg [n-1:0] irq_ack;
reg [n-1:0] irq_pending;

assign ack = irq_ack; // Changed this to assign directly to the ack register

// Priority encoder to determine the highest priority interrupt request
always @ (irq) begin
  casez(irq)
    4'b0001: irq_priority = 4'b1000; // Priority level 1
    4'b0010: irq_priority = 4'b0100; // Priority level 2
    4'b0100: irq_priority = 4'b0010; // Priority level 3
    4'b1000: irq_priority = 4'b0001; // Priority level 4
    default: irq_priority = 4'b0000; // No interrupt request
  endcase
end

// State machine to manage the interrupt acknowledge signals
always @ (posedge clk or posedge reset) begin
  if (reset) begin
    irq_ack <= 0;
    irq_pending <= 0;
  end else begin
    if (irq_priority > irq_ack) begin
      irq_ack <= irq_priority;
      irq_pending <= irq & ~irq_ack;
    end else if (irq_pending != 0) begin
      irq_ack <= irq_pending & ~irq_ack;
      irq_pending <= irq_pending & irq_ack;
    end else begin
      irq_ack <= 0;
    end
  end
end

endmodule