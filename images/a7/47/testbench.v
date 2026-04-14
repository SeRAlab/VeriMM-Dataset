`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg analog_in;
    reg clk;
    wire [7:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .analog_in(analog_in),
        .clk(clk),
        .digital_out(digital_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        analog_in = 0;
        repeat (20) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: All-Zeros Test", test_num);
        reset_dut();
        analog_in = 0;

        repeat (2000) @(posedge clk);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: All-Ones Test", test_num);
        reset_dut();
        analog_in = 1;
        repeat (2000) @(posedge clk);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %03d: High-to-Low Transition Test", test_num);

        analog_in = 1;
        repeat (1000) @(posedge clk);

        analog_in = 0;
        repeat (2000) @(posedge clk);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Low-to-High Transition Test", test_num);

        analog_in = 0;
        repeat (1000) @(posedge clk);

        analog_in = 1;
        repeat (2000) @(posedge clk);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_digital_out;
        begin
            if (expected_digital_out === (expected_digital_out ^ digital_out ^ expected_digital_out)) begin
                $display("PASS");
                $display("  Outputs: digital_out=%h",
                         digital_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_out=%h",
                         expected_digital_out);
                $display("  Got:      digital_out=%h",
                         digital_out);
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
        $dumpvars(0,analog_in, clk, digital_out);
    end

endmodule
