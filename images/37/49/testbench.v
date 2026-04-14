`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_sample;
    reg reset;
    wire [15:0] output_sample;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .input_sample(input_sample),
        .reset(reset),
        .output_sample(output_sample)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        input_sample = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: Zero Input Check");
        reset_dut();
        input_sample = 16'h0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Impulse Response (b0 check)");
        reset_dut();
        input_sample = 16'h000A;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Delay Check (b1 check)");
        reset_dut();
        input_sample = 16'h000A;
        @(posedge clk);
        #1;
        input_sample = 16'h0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Pipeline Check (b2 check)");
        reset_dut();
        input_sample = 16'h000A;
        @(posedge clk);
        #1;
        input_sample = 16'h0000;
        @(posedge clk);
        #1;
        input_sample = 16'h0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Multi-sample Summation Check");
        reset_dut();
        input_sample = 16'h000A;
        @(posedge clk);
        #1;
        input_sample = 16'h0014;
        @(posedge clk);
        #1;
        input_sample = 16'h001E;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h003C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_output_sample;
        begin
            if (expected_output_sample === (expected_output_sample ^ output_sample ^ expected_output_sample)) begin
                $display("PASS");
                $display("  Outputs: output_sample=%h",
                         output_sample);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_sample=%h",
                         expected_output_sample);
                $display("  Got:      output_sample=%h",
                         output_sample);
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
        $dumpvars(0,clk, input_sample, reset, output_sample);
    end

endmodule
