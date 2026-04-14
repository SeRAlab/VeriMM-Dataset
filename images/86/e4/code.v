module top_module(
    address,
    clock,
    data_in,
    write_en,
    data_out
);input [9:0] address;
    input clock;
    input [11:0] data_in;
    input write_en;
    output reg [11:0] data_out; // Changed wire to reg

    reg [11:0] mem[1023:0];

    always @(posedge clock) begin
        if (write_en) begin
            mem[address] <= data_in;
        end
        data_out <= mem[address]; // data_out can now be assigned
    end

endmodule