module shift_register
    (
        input clk,
        input serial_in,
        output reg [3:0] parallel_out
    );

    always @(posedge clk) 
    begin
        parallel_out <= {serial_in, parallel_out[3:1]};
    end

endmodule