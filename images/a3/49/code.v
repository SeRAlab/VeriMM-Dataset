module top_module(
  input clk,
  input [6:0] addr,
  input [15:0] di,
  input we,
  input eoc,
  output reg busy,
  output reg [4:0] channel,
  output reg [15:0] dout,
  output reg drdy,
  output reg eoc_out,
  output reg [2:0] jtag_busy,  // Changed to reg
  output reg jtag_locked,      // Changed to reg
  output reg jtag_modified     // Changed to reg
);localparam IDLE = 3'b000, READ = 3'b001, PROCESS = 3'b010, WRITE = 3'b011;
  reg [2:0] state;
  reg [15:0] data;
  
  always @(posedge clk) begin
    case (state)
      IDLE: begin
        busy <= 0;
        channel <= 0;
        dout <= 0;
        drdy <= 0;
        eoc_out <= 0;
        jtag_busy <= 0;         // Can now assign because jtag_busy is reg
        jtag_locked <= 0;       // Can now assign because jtag_locked is reg
        jtag_modified <= 0;     // Can now assign because jtag_modified is reg
        if (eoc) begin
          state <= READ;
        end
      end
      READ: begin
        busy <= 1;
        channel <= addr[4:0];
        dout <= 16'h0000;
        drdy <= 0;
        eoc_out <= 0;
        jtag_busy <= 0;         // Can now assign because jtag_busy is reg
        jtag_locked <= 0;       // Can now assign because jtag_locked is reg
        jtag_modified <= 0;     // Can now assign because jtag_modified is reg
        state <= PROCESS;
      end
      PROCESS: begin
        busy <= 1;
        channel <= addr[4:0];
        dout <= 16'h0000;
        drdy <= 0;
        eoc_out <= 0;
        jtag_busy <= 0;         // Can now assign because jtag_busy is reg
        jtag_locked <= 0;       // Can now assign because jtag_locked is reg
        jtag_modified <= 0;     // Can now assign because jtag_modified is reg
        if (!eoc) begin
          state <= PROCESS;
        end else begin
          state <= WRITE;
        end
      end
      WRITE: begin
        busy <= 1;
        channel <= addr[4:0];
        dout <= data;
        drdy <= 1;
        eoc_out <= 1;
        jtag_busy <= 0;         // Can now assign because jtag_busy is reg
        jtag_locked <= 0;       // Can now assign because jtag_locked is reg
        jtag_modified <= 0;     // Can now assign because jtag_modified is reg
        if (!we) begin
          state <= IDLE;
        end
      end
    endcase
  end
  
  always @(posedge clk) begin
    case (state)
      IDLE: begin
        data <= 16'h0000;
      end
      READ: begin
        data <= 16'h0000;
      end
      PROCESS: begin
        data <= di;
      end
      WRITE: begin
        data <= 16'h0000;
      end
    endcase
  end

endmodule