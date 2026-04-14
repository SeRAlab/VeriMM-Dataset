module top_module(
    input clock,
    input IO_write,
    input [11:0] IO_address,
    input [15:0] IO_data_in,
    input [15:0] processor_input,
    output reg [15:0] IO_data_out,
    output reg [15:0] processor_output
);reg [15:0] memory [0:4095];

always @(posedge clock) begin
    if (IO_write) begin
        memory[IO_address] <= IO_data_in;
    end else begin
        IO_data_out <= memory[IO_address];
    end
    processor_output <= processor_input;
end

endmodule