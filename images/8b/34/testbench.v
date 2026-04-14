`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CTRL;
    wire [7:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CTRL(CTRL),
        .RESULT(RESULT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Addition (CTRL=0, A=10, B=20)", test_num);
        A = 8'd10;
        B = 8'd20;
        CTRL = 1'b0;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Subtraction (CTRL=1, A=50, B=20)", test_num);
        A = 8'd50;
        B = 8'd20;
        CTRL = 1'b1;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Overflow (CTRL=0, A=250, B=10)", test_num);
        A = 8'd250;
        B = 8'd10;
        CTRL = 1'b0;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Underflow (CTRL=1, A=5, B=10)", test_num);
        A = 8'd5;
        B = 8'd10;
        CTRL = 1'b1;
        #1;

        check_outputs(8'hFB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Value Addition (CTRL=0, A=255, B=255)", test_num);
        A = 8'hFF;
        B = 8'hFF;
        CTRL = 1'b0;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtract to Zero (CTRL=1, A=128, B=128)", test_num);
        A = 8'd128;
        B = 8'd128;
        CTRL = 1'b1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Inputs Addition (CTRL=0, A=0, B=0)", test_num);
        A = 8'd0;
        B = 8'd0;
        CTRL = 1'b0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtract from Zero (CTRL=1, A=0, B=1)", test_num);
        A = 8'd0;
        B = 8'd1;
        CTRL = 1'b1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
