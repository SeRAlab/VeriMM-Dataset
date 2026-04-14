module top_module(
  input clock,
  input reset,
  input read_en,
  input write_en,
  input [31:0] address,
  input [width-1:0] data_in,
  output reg [width-1:0] data_out, // Change wire to reg
  output done
);parameter width = 32; // width of the data bus in bits
parameter depth = 1024; // depth of the memory array

reg [width-1:0] memory [0:depth-1]; // memory array

reg read_done; // read operation done signal
reg write_done; // write operation done signal

always @(posedge clock) begin
  if (reset) begin
    read_done <= 0;
    write_done <= 0;
    data_out <= 0; // Initialize data_out on reset
  end else begin
    if (read_en) begin
      data_out <= memory[address];
      read_done <= 1;
    end else begin
      read_done <= 0;
    end

    if (write_en) begin
      memory[address] <= data_in;
      write_done <= 1;
    end else begin
      write_done <= 0;
    end
  end
end

assign done = read_done | write_done;

endmodule