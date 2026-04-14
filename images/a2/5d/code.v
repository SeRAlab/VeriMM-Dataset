module shift_register(
    input clk,
    input load,
    input [3:0] data_in,
    output reg data_out
    );

    reg [3:0] register;

    always @(posedge clk) begin
        if (load) begin
            register <= data_in;
        end else begin
            register <= register >> 1;
        end
        data_out <= register[0];
    end
endmodule