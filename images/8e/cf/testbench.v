`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rst_n;
    reg sysclk;
    wire cmos_pwdn;
    wire cmos_reset;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rst_n(rst_n),
        .sysclk(sysclk),
        .cmos_pwdn(cmos_pwdn),
        .cmos_reset(cmos_reset),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        rst_n = 0;
        forever #5 rst_n = ~rst_n;
    end

        task reset_dut;

        begin
            rst_n = 0;
            #100;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial State (Power Down Active)", test_num);
            reset_dut();
            #1000;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: After 6ms (PWDN Release)", test_num);
            reset_dut();
            #6000100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: After 8ms (Reset Release)", test_num);
            reset_dut();
            #8000100;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: After 21ms (Initialization Done)", test_num);
            reset_dut();
            #21000100;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_cmos_pwdn;
        input expected_cmos_reset;
        input expected_done;
        begin
            if (expected_cmos_pwdn === (expected_cmos_pwdn ^ cmos_pwdn ^ expected_cmos_pwdn) &&
                expected_cmos_reset === (expected_cmos_reset ^ cmos_reset ^ expected_cmos_reset) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: cmos_pwdn=%b, cmos_reset=%b, done=%b",
                         cmos_pwdn, cmos_reset, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmos_pwdn=%b, cmos_reset=%b, done=%b",
                         expected_cmos_pwdn, expected_cmos_reset, expected_done);
                $display("  Got:      cmos_pwdn=%b, cmos_reset=%b, done=%b",
                         cmos_pwdn, cmos_reset, done);
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
        $dumpvars(0,rst_n, sysclk, cmos_pwdn, cmos_reset, done);
    end

endmodule
