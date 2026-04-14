`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg clk;
    reg load;
    wire Q0;
    wire Q1;
    wire Q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .load(load),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d...", test_num);
            A = 0;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 1;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 1;
            load = 1;
            @(posedge clk);
            A = 0;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 1;
            load = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 1;
            load = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 1; load = 1;
            @(posedge clk);
            A = 0; load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 1; load = 1;
            @(posedge clk);
            A = 0; load = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            load = 0;
            A = 1; @(posedge clk);
            A = 0; @(posedge clk);
            A = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            A = 1; load = 0;
            @(posedge clk);

            A = 0; load = 1;
            @(posedge clk);
            #1;
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_Q0;
        input expected_Q1;
        input expected_Q2;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b, Q1=%b, Q2=%b",
                         Q0, Q1, Q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b, Q1=%b, Q2=%b",
                         expected_Q0, expected_Q1, expected_Q2);
                $display("  Got:      Q0=%b, Q1=%b, Q2=%b",
                         Q0, Q1, Q2);
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
        $dumpvars(0,A, clk, load, Q0, Q1, Q2);
    end

endmodule
