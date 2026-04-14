module top_module(
    clk,
    load,
    data_in,
    parallel_load,
    parallel_data_in,
    serial_out
);input clk;
    input load;
    input data_in;
    input parallel_load;
    input [7:0] parallel_data_in; // Change to [7:0] to match data width
    output serial_out;

    reg [7:0] register; // Change wire to reg to allow assignment in always block

    assign serial_out = register[7];

    always @(posedge clk) begin
        if (load) begin
            register <= {data_in, register[7:1]};
        end else if (parallel_load) begin
            register <= parallel_data_in;
        end else begin
            register <= {register[6:0], data_in};
        end
    end

endmodule