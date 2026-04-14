module top_module(
    input clk,
    input reset,
    input load,
    input ena,
    input select,
    input [3:0] counter_out,
    input [7:0] register_out,
    output [7:0] final_output
);// 4-bit binary counter module
    reg [3:0] counter;
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            counter <= 0;
        end else if (counter == 15) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    // 8-bit shift register module
    reg [7:0] register;
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            register <= 0;
        end else if (load == 1) begin
            register <= register_out;
        end else if (ena == 1) begin
            register <= {register[6:0], register[7]};
        end
    end

    // Functional module that performs bitwise OR operation
    reg [7:0] or_output;
    always @(*) begin
        if (select == 0) begin
            or_output = counter_out | 8'b00000000;
        end else begin
            or_output = 4'b0000 | register_out;
        end
    end

    // Output final result
    assign final_output = or_output;

endmodule