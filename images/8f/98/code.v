module top_module(
  input clk,
  input rst,
  input din,
  input [1:0] cin,
  output dout
);// parameter declaration
parameter WIDTH = 1; // data width of the input and output
parameter HIGH = 1'b1; // high signal
parameter LOW = 1'b0; // low signal

// implementation of D-latch
reg [WIDTH-1:0] d_latch;
always @(posedge clk) begin
  if (rst) begin
    d_latch <= LOW;
  end else begin
    d_latch <= din;
  end
end

// implementation of JK-latch
reg [WIDTH-1:0] jk_latch;
always @(posedge clk) begin
  if (rst) begin
    jk_latch <= LOW;
  end else begin
    if (cin == 2'b01 && din && jk_latch) begin // toggle
      jk_latch <= ~jk_latch;
    end else if (cin == 2'b01 && din && ~jk_latch) begin // set
      jk_latch <= HIGH;
    end else if (cin == 2'b01 && ~din && jk_latch) begin // reset
      jk_latch <= LOW;
    end
  end
end

// implementation of T-latch
reg [WIDTH-1:0] t_latch;
always @(posedge clk) begin
  if (rst) begin
    t_latch <= LOW;
  end else begin
    if (cin == 2'b10 && din) begin // toggle
      t_latch <= ~t_latch;
    end
  end
end

// implementation of SR-latch
reg [WIDTH-1:0] sr_latch;
always @(posedge clk) begin
  if (rst) begin
    sr_latch <= LOW;
  end else begin
    if (cin == 2'b11 && din && ~sr_latch) begin // set
      sr_latch <= HIGH;
    end else if (cin == 2'b11 && ~din && sr_latch) begin // reset
      sr_latch <= LOW;
    end
  end
end

// multiplexer to select the appropriate latch
wire [WIDTH-1:0] selected_latch;
assign selected_latch = (cin == 2'b00) ? d_latch :
                       (cin == 2'b01) ? jk_latch :
                       (cin == 2'b10) ? t_latch :
                       sr_latch;

// output
assign dout = selected_latch;

endmodule