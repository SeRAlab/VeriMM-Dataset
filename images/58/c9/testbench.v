`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg analog_in;
    reg clk;
    reg digital_in;
    wire analog_out;
    wire digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .analog_in(analog_in),
        .clk(clk),
        .digital_in(digital_in),
        .analog_out(analog_out),
        .digital_out(digital_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            analog_in = 0;
            digital_in = 0;



            repeat(32) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Minimum signal levels (All 0s)", test_num);
            reset_dut();

            analog_in = 0;
            digital_in = 0;


            repeat(64) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum signal levels (All 1s)", test_num);
            reset_dut();

            analog_in = 1;
            digital_in = 1;


            repeat(64) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mixed inputs (A_in=1, D_in=0)", test_num);
            reset_dut();

            analog_in = 1;
            digital_in = 0;

            repeat(64) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transient response (0 -> 1 Transition)", test_num);
            reset_dut();

            @(posedge clk);
            analog_in = 1;
            digital_in = 1;



            repeat(128) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transient response (1 -> 0 Transition)", test_num);
            reset_dut();


            analog_in = 1;
            digital_in = 1;
            repeat(64) @(posedge clk);


            analog_in = 0;
            digital_in = 0;
            repeat(128) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_analog_out;
        input expected_digital_out;
        begin
            if (expected_analog_out === (expected_analog_out ^ analog_out ^ expected_analog_out) &&
                expected_digital_out === (expected_digital_out ^ digital_out ^ expected_digital_out)) begin
                $display("PASS");
                $display("  Outputs: analog_out=%b, digital_out=%b",
                         analog_out, digital_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_out=%b, digital_out=%b",
                         expected_analog_out, expected_digital_out);
                $display("  Got:      analog_out=%b, digital_out=%b",
                         analog_out, digital_out);
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
        $dumpvars(0,analog_in, clk, digital_in, analog_out, digital_out);
    end

endmodule
