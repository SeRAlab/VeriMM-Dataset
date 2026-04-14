`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg X;
    reg clock;
    wire A;
    wire B;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .clock(clock),
        .A(A),
        .B(B),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        X = 0;
        @(posedge clock);
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Transition (0,0) -> (1,1) and check Y=1 when X=0", test_num);
        reset_dut();
        X = 1;
        @(posedge clock);
        #1;
        X = 0;
        #1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Transition (1,1) -> (1,0) via X=1", test_num);
        reset_dut();
        X = 1;
        @(posedge clock);
        #1;
        X = 1;
        @(posedge clock);
        #1;
        X = 0;
        #1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Stay in (0,0) with X=0", test_num);
        reset_dut();
        X = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Transition (1,1) -> (1,0) via X=0", test_num);
        reset_dut();
        X = 1;
        @(posedge clock);
        #1;
        X = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Full cycle (0,0)->(1,1)->(1,0)->(0,0)", test_num);
        reset_dut();
        X = 1;
        @(posedge clock);
        #1;
        X = 0;
        @(posedge clock);
        #1;
        X = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_A;
        input expected_B;
        input expected_Y;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: A=%b, B=%b, Y=%b",
                         A, B, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b, B=%b, Y=%b",
                         expected_A, expected_B, expected_Y);
                $display("  Got:      A=%b, B=%b, Y=%b",
                         A, B, Y);
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
        $dumpvars(0,X, clock, A, B, Y);
    end

endmodule
