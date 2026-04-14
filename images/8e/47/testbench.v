`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg C;
    wire [7:0] Difference;
    wire [7:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Difference(Difference),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (C=1) - Simple values", test_num);
        A = 8'd10;
        B = 8'd20;
        C = 1'b1;
        #1;

        check_outputs(8'h00, 8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (C=0) - Simple values", test_num);
        A = 8'd50;
        B = 8'd20;
        C = 1'b0;
        #1;

        check_outputs(8'd30, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (C=1) - Overflow case", test_num);
        A = 8'd255;
        B = 8'd5;
        C = 1'b1;
        #1;

        check_outputs(8'h00, 8'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (C=0) - Underflow case", test_num);
        A = 8'd10;
        B = 8'd20;
        C = 1'b0;
        #1;

        check_outputs(8'd246, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (C=1) - Zero values", test_num);
        A = 8'h00;
        B = 8'h00;
        C = 1'b1;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (C=0) - Max values", test_num);
        A = 8'hFF;
        B = 8'hFF;
        C = 1'b0;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (C=1) - Max values", test_num);
        A = 8'hFF;
        B = 8'hFF;
        C = 1'b1;
        #1;

        check_outputs(8'h00, 8'hFE);
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
        input [7:0] expected_Difference;
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Difference === (expected_Difference ^ Difference ^ expected_Difference) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Difference=%h, Sum=%h",
                         Difference, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Difference=%h, Sum=%h",
                         expected_Difference, expected_Sum);
                $display("  Got:      Difference=%h, Sum=%h",
                         Difference, Sum);
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
