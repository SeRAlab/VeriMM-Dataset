`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simple Positive Addition", test_num);
        A = 32'sd100;
        B = 32'sd200;
        #1;

        check_outputs(32'sd300);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simple Negative Addition", test_num);
        A = -32'sd100;
        B = -32'sd200;
        #1;

        check_outputs(-32'sd300);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Positive and Negative (Positive result)", test_num);
        A = 32'sd500;
        B = -32'sd200;
        #1;

        check_outputs(32'sd300);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Positive and Negative (Negative result)", test_num);
        A = 32'sd200;
        B = -32'sd500;
        #1;

        check_outputs(-32'sd300);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Addition with Zero", test_num);
        A = 32'sd0;
        B = -32'sd12345;
        #1;

        check_outputs(-32'sd12345);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Max Positive Wrap-around", test_num);
        A = 32'h7FFFFFFF;
        B = 32'sd1;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Min Negative Wrap-around", test_num);
        A = 32'h80000000;
        B = -32'sd1;
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Max Positive and Min Negative", test_num);
        A = 32'h7FFFFFFF;
        B = 32'h80000000;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Zero + Zero", test_num);
        A = 32'sd0;
        B = 32'sd0;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Large Signed Values", test_num);
        A = 32'sd12345678;
        B = 32'sd87654321;
        #1;

        check_outputs(32'sd99999999);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
