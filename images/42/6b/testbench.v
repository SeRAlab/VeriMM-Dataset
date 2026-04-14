`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            A = 4'd0;
            B = 4'd0;
            repeat (10) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd0;
            B = 4'd0;

            repeat (10) @(posedge CLK);
            $display("Test Case 001: 0 x 0");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd1;
            B = 4'd1;
            repeat (10) @(posedge CLK);
            $display("Test Case 002: 1 x 1");
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            repeat (10) @(posedge CLK);
            $display("Test Case 003: 15 x 15");
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            repeat (10) @(posedge CLK);
            $display("Test Case 004: 5 x 3");
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd10;
            B = 4'd2;
            repeat (10) @(posedge CLK);
            $display("Test Case 005: 10 x 2");
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd7;
            B = 4'd8;
            repeat (10) @(posedge CLK);
            $display("Test Case 006: 7 x 8");
            #1;

            check_outputs(8'd56);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd15;
            B = 4'd0;
            repeat (10) @(posedge CLK);
            $display("Test Case 007: 15 x 0");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd0;
            B = 4'd15;
            repeat (10) @(posedge CLK);
            $display("Test Case 008: 0 x 15");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd13;
            B = 4'd7;
            repeat (10) @(posedge CLK);
            $display("Test Case 009: 13 x 7");
            #1;

            check_outputs(8'd91);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd4;
            B = 4'd4;
            repeat (10) @(posedge CLK);
            $display("Test Case 010: 4 x 4");
            #1;

            check_outputs(8'd16);
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
        testcase010();
        
        
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
        input [7:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, B, CLK, Y);
    end

endmodule
