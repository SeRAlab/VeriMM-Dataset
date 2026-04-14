module top_module(
  input [n-1:0] irq,
  input ack,
  output reg [7:0] vec // Change output to reg type
);parameter n = 4; // number of interrupt request signals

reg [n-1:0] irq_priority; // priority of interrupt requests
reg [n-1:0] irq_pending; // pending interrupt requests
reg [n-1:0] irq_clear; // clear interrupt requests

always @(*) begin
  // prioritize interrupt requests based on severity and order
  irq_priority[0] = irq[0];
  irq_priority[1] = irq[1];
  irq_priority[2] = irq[2];
  irq_priority[3] = irq[3];
  
  // set pending interrupt requests
  irq_pending = irq_priority & ~irq_clear;
end

always @(posedge ack) begin
  // send highest priority interrupt to processor
  if (irq_pending[0]) begin
    vec = 8'h01;
    irq_clear[0] = 1;
  end else if (irq_pending[1]) begin
    vec = 8'h02;
    irq_clear[1] = 1;
  end else if (irq_pending[2]) begin
    vec = 8'h03;
    irq_clear[2] = 1;
  end else if (irq_pending[3]) begin
    vec = 8'h04;
    irq_clear[3] = 1;
  end else begin
    vec = 8'h00;
  end
end

endmodule