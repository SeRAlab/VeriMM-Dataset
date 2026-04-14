`timescale 1ns/1ps

module JK_latch_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_latch dut (
        .J(J),
        .K(K),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        J = 0;
        K = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: Set Operation (J=1, K=0)");
        reset_dut();
        test_num = test_num + 1;
        J = 1;
        K = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Reset Operation (J=0, K=1)");
        reset_dut();
        test_num = test_num + 1;
        J = 0;
        K = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Hold Operation (J=0, K=0) while Q=0");
        reset_dut();
        test_num = test_num + 1;
        J = 0;
        K = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Hold Operation (J=0, K=0) while Q=1");
        reset_dut();

        J = 1; K = 0;
        @(posedge clk);
        #1;

        test_num = test_num + 1;
        J = 0;
        K = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Toggle Operation (J=1, K=1) while Q=0");
        reset_dut();
        test_num = test_num + 1;
        J = 1;
        K = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Toggle Operation (J=1, K=1) while Q=1");
        reset_dut();

        J = 1; K = 0;
        @(posedge clk);
        #1;

        test_num = test_num + 1;
        J = 1;
        K = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JK_latch Testbench");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,J, K, clk, Q);
    end

endmodule
