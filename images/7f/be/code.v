module top_module(full,
    O1,
    Q,
    O2,
    I1,
    wr_clk,
    rst_d2,
    wr_en,
    RD_PNTR_WR,
    rst_full_gen_i,
    I2);output reg full;                 // Changed to reg
  output reg O1;                   // Changed to reg
  output reg [0:0] Q;              // Changed to reg
  output reg [8:0] O2;             // Changed to reg
  input [0:0] I1;
  input wr_clk;
  input rst_d2;
  input wr_en;
  input [8:0] RD_PNTR_WR;
  input rst_full_gen_i;
  input [0:0] I2;

  reg [31:0] fifo [0:31];
  reg [4:0] write_pointer;
  reg [4:0] read_pointer;          // Changed to reg
  reg [3:0] counter;
  
  // Write logic
  always @(posedge wr_clk or posedge rst_d2) begin
    if (rst_d2) begin
      write_pointer <= 0;
      counter <= 0;
      full <= 0;
    end else if (wr_en && !full) begin
      fifo[write_pointer] <= {31'b0, I1}; // Assuming I1 is a 1-bit input
      write_pointer <= write_pointer + 1;
      counter <= counter + 1;
      
      if (write_pointer == 31) begin
        full <= 1;
      end
    end
  end

  // Read logic
  assign empty = (write_pointer == read_pointer) && !full;
  always @(posedge wr_clk or posedge rst_full_gen_i) begin
    if (rst_full_gen_i) begin
      read_pointer <= 0;
    end else if (!empty) begin
      Q <= fifo[read_pointer];      // Q is an output reg
      read_pointer <= read_pointer + 1;
      O1 <= 1;
      
      if (read_pointer == 31) begin
        O1 <= 0;
      end
      if (read_pointer == RD_PNTR_WR) begin
        O1 <= 0;
      end
    end
  end

  // Counter logic
  always @(posedge wr_clk) begin
    O2 <= {counter};                // Assuming O2 can hold 9 bits; proper assignment
  end

endmodule