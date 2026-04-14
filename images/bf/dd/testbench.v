`timescale 1ns/1ps

module arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_a;
    reg input_a_stb;
    reg [15:0] input_b;
    reg input_b_stb;
    reg output_z_ack;
    reg rst;
    wire input_a_ack;
    wire input_b_ack;
    wire [15:0] output_z;
    wire output_z_stb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arbiter dut (
        .clk(clk),
        .input_a(input_a),
        .input_a_stb(input_a_stb),
        .input_b(input_b),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .rst(rst),
        .input_a_ack(input_a_ack),
        .input_b_ack(input_b_ack),
        .output_z(output_z),
        .output_z_stb(output_z_stb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arbiter Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_input_a_ack;
        input expected_input_b_ack;
        input [15:0] expected_output_z;
        input expected_output_z_stb;
        begin
            if (expected_input_a_ack === (expected_input_a_ack ^ input_a_ack ^ expected_input_a_ack) &&
                expected_input_b_ack === (expected_input_b_ack ^ input_b_ack ^ expected_input_b_ack) &&
                expected_output_z === (expected_output_z ^ output_z ^ expected_output_z) &&
                expected_output_z_stb === (expected_output_z_stb ^ output_z_stb ^ expected_output_z_stb)) begin
                $display("PASS");
                $display("  Outputs: input_a_ack=%b, input_b_ack=%b, output_z=%h, output_z_stb=%b",
                         input_a_ack, input_b_ack, output_z, output_z_stb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: input_a_ack=%b, input_b_ack=%b, output_z=%h, output_z_stb=%b",
                         expected_input_a_ack, expected_input_b_ack, expected_output_z, expected_output_z_stb);
                $display("  Got:      input_a_ack=%b, input_b_ack=%b, output_z=%h, output_z_stb=%b",
                         input_a_ack, input_b_ack, output_z, output_z_stb);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, input_a, input_a_stb, input_b, input_b_stb, output_z_ack, rst, input_a_ack, input_b_ack, output_z, output_z_stb);
    end

endmodule
