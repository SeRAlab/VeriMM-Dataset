`timescale 1ns/1ps

module arithmetic_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arithmetic_module dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
        A = 8'd0;
        B = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Small Values (10 + 20)", test_num);
        A = 8'd10;
        B = 8'd20;
        #1;

        check_outputs(16'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Maximum 8-bit Values (255 + 255)", test_num);
        A = 8'hFF;
        B = 8'hFF;
        #1;

        check_outputs(16'd510);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Power of Two Boundary (127 + 1)", test_num);
        A = 8'd127;
        B = 8'd1;
        #1;

        check_outputs(16'd128);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Overflowing 8-bit Sum (200 + 100)", test_num);
        A = 8'd200;
        B = 8'd100;
        #1;

        check_outputs(16'd300);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Single Sided Max (255 + 0)", test_num);
        A = 8'hFF;
        B = 8'h00;
        #1;

        check_outputs(16'd255);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Symmetric Input (128 + 128)", test_num);
        A = 8'd128;
        B = 8'd128;
        #1;

        check_outputs(16'd256);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arithmetic_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
