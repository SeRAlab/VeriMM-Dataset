`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg sub;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sub(sub),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0; B = 4'd0; sub = 1'b0;
        #10;
        $display("Test %0d: A=0, B=0, sub=0 (Addition)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd5; B = 4'd3; sub = 1'b0;
        #10;
        $display("Test %0d: A=5, B=3, sub=0 (Addition)", test_num);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd12; B = 4'd7; sub = 1'b0;
        #10;
        $display("Test %0d: A=12, B=7, sub=0 (Addition with Overflow)", test_num);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd15; B = 4'd1; sub = 1'b0;
        #10;
        $display("Test %0d: A=15, B=1, sub=0 (Addition at Max Boundary)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd8; B = 4'd8; sub = 1'b1;
        #10;
        $display("Test %0d: A=8, B=8, sub=1 (Subtraction)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd10; B = 4'd4; sub = 1'b1;
        #10;
        $display("Test %0d: A=10, B=4, sub=1 (Subtraction Positive Result)", test_num);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd4; B = 4'd10; sub = 1'b1;
        #10;
        $display("Test %0d: A=4, B=10, sub=1 (Subtraction Negative Result)", test_num);
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd0; B = 4'd1; sub = 1'b1;
        #10;
        $display("Test %0d: A=0, B=1, sub=1 (Subtraction Wrap-around)", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd15; B = 4'd0; sub = 1'b1;
        #10;
        $display("Test %0d: A=15, B=0, sub=1 (Subtraction Identity)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'hF; B = 4'hF; sub = 1'b0;
        #10;
        $display("Test %0d: A=F, B=F, sub=0 (Max Addition)", test_num);
        #1;

        check_outputs(4'hE);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
