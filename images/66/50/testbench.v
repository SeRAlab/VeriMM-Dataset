`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg sig;
    wire fall_edge;
    wire rise_edge;
    wire sig_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .sig(sig),
        .fall_edge(fall_edge),
        .rise_edge(rise_edge),
        .sig_edge(sig_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            sig = 0;
            #20;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rising Edge", test_num);
            reset_dut();


            sig <= 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Falling Edge", test_num);
            reset_dut();


            sig <= 1;
            repeat(2) @(posedge clk);


            sig <= 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Steady Low", test_num);
            reset_dut();

            sig <= 0;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Steady High", test_num);
            reset_dut();


            sig <= 1;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Quick Pulse", test_num);
            reset_dut();


            sig <= 1;
            @(posedge clk);
            sig <= 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset behavior", test_num);
            reset_dut();

            sig <= 1;
            @(posedge clk);
            rst_n <= 0;
            #2;


            #1;



            check_outputs(0, 0, 0);
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
        testcase006();
        
        
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
        input expected_fall_edge;
        input expected_rise_edge;
        input expected_sig_edge;
        begin
            if (expected_fall_edge === (expected_fall_edge ^ fall_edge ^ expected_fall_edge) &&
                expected_rise_edge === (expected_rise_edge ^ rise_edge ^ expected_rise_edge) &&
                expected_sig_edge === (expected_sig_edge ^ sig_edge ^ expected_sig_edge)) begin
                $display("PASS");
                $display("  Outputs: fall_edge=%b, rise_edge=%b, sig_edge=%b",
                         fall_edge, rise_edge, sig_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fall_edge=%b, rise_edge=%b, sig_edge=%b",
                         expected_fall_edge, expected_rise_edge, expected_sig_edge);
                $display("  Got:      fall_edge=%b, rise_edge=%b, sig_edge=%b",
                         fall_edge, rise_edge, sig_edge);
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
        $dumpvars(0,clk, rst_n, sig, fall_edge, rise_edge, sig_edge);
    end

endmodule
