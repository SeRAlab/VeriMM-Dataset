module top_module(
  input [n-1:0] irq,
  output [m-1:0] iak
);parameter n = 4; // number of IRQ signals
parameter m = 2; // number of IAK signals
parameter p = 3; // number of priority levels

reg [n-1:0] irq_priority; // priority level for each IRQ signal
reg [n-1:0] irq_active; // active status for each IRQ signal
reg [p-1:0] highest_priority; // highest priority level
reg [m-1:0] iak_active; // active status for each IAK signal
integer i; // Declare integer `i` for loops

// assign priority levels to each IRQ signal
initial begin
  irq_priority[0] = 2;
  irq_priority[1] = 1;
  irq_priority[2] = 0;
  irq_priority[3] = 1;
end

// detect active IRQ signals
always @ (irq) begin
  for (i = 0; i < n; i = i + 1) begin
    if (irq[i] == 1) begin
      irq_active[i] = 1;
    end else begin
      irq_active[i] = 0;
    end
  end
end

// detect highest priority IRQ signal
always @ (irq_active) begin
  highest_priority = p;
  for (i = 0; i < n; i = i + 1) begin
    if (irq_active[i] == 1 && irq_priority[i] < highest_priority) begin
      highest_priority = irq_priority[i];
    end
  end
end

// generate IAK signals for highest priority IRQ signal
always @ (highest_priority) begin
  for (i = 0; i < m; i = i + 1) begin
    if (i == highest_priority) begin
      iak_active[i] = 1;
    end else begin
      iak_active[i] = 0;
    end
  end
end

// assign IAK signals to output
assign iak = iak_active;

endmodule