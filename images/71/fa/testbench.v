`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    wire fe;
    wire re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .fe(fe),
        .re(re)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;

            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in = 1;
            @(posedge clk);
            @(negedge clk);
            $display("Testcase 001: Rising Edge Detection");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            in = 1;
            @(posedge clk);
            @(posedge clk);

            in = 0;
            @(posedge clk);
            @(negedge clk);
            $display("Testcase 002: Falling Edge Detection");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in = 0;
            @(posedge clk);
            @(negedge clk);
            $display("Testcase 003: Steady State LOW");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in = 1;
            @(posedge clk);
            @(posedge clk);
            in = 1;
            @(posedge clk);
            @(negedge clk);
            $display("Testcase 004: Steady State HIGH");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in = 1;
            @(posedge clk);
            in = 0;
            @(posedge clk);
            @(negedge clk);
            $display("Testcase 005: Falling Edge Immediately after Rising Edge");
            #1;

            check_outputs(1, 0);
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
        input expected_fe;
        input expected_re;
        begin
            if (expected_fe === (expected_fe ^ fe ^ expected_fe) &&
                expected_re === (expected_re ^ re ^ expected_re)) begin
                $display("PASS");
                $display("  Outputs: fe=%b, re=%b",
                         fe, re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fe=%b, re=%b",
                         expected_fe, expected_re);
                $display("  Got:      fe=%b, re=%b",
                         fe, re);
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
        $dumpvars(0,clk, in, fe, re);
    end

endmodule
