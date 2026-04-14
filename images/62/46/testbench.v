`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg CLK;
    reg CLR;
    reg EN;
    wire X;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .CLR(CLR),
        .EN(EN),
        .X(X),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            EN = 0;
            CLR = 1;
            @(posedge CLK);
            #1;
            CLR = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Capture (A=1, B=1)", test_num);
            reset_dut();
            A = 1; B = 1; EN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Persistence in S1 and S2", test_num);
            reset_dut();
            A = 1; B = 0; EN = 1;
            @(posedge CLK);
            #1;
            A = 0; B = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Signal Control", test_num);
            reset_dut();
            A = 0; B = 1; EN = 1;
            @(posedge CLK);
            #1;
            EN = 0;
            A = 1; B = 1;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Clear", test_num);
            reset_dut();
            A = 1; B = 1; EN = 1;
            @(posedge CLK);
            #1;
            CLR = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Loop Cycle and Re-capture", test_num);
            reset_dut();

            A = 1; B = 1; EN = 1;
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;

            A = 0; B = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(0, 1);
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
        input expected_X;
        input expected_Y;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: X=%b, Y=%b",
                         X, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b, Y=%b",
                         expected_X, expected_Y);
                $display("  Got:      X=%b, Y=%b",
                         X, Y);
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
        $dumpvars(0,A, B, CLK, CLR, EN, X, Y);
    end

endmodule
