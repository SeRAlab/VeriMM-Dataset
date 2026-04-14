`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ce;
    reg clk;
    reg clr;
    wire [7:0] op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .op(op)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Default Input State", test_num);

        clk = 0;
        ce = 0;
        clr = 0;
        #10;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Clear Signal Asserted", test_num);

        clr = 1;
        ce = 0;
        clk = 0;
        #10;

        #1;


        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Clocking with Clock Enable High", test_num);
        clr = 0;
        ce = 1;

        repeat(5) begin
            clk = 1; #5;
            clk = 0; #5;
        end
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Clocking with Clock Enable Low", test_num);
        clr = 0;
        ce = 0;

        repeat(5) begin
            clk = 1; #5;
            clk = 0; #5;
        end
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Signals High", test_num);
        clr = 1;
        ce = 1;
        clk = 1;
        #20;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Rapid Toggle of Control Signals", test_num);
        clr = 0; ce = 0; clk = 0;
        #5 clr = 1;
        #5 ce = 1;
        #5 clr = 0;
        #5 clk = 1;
        #5 ce = 0;
        #1;

        check_outputs(8'h06);
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
        input [7:0] expected_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%h",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h",
                         expected_op);
                $display("  Got:      op=%h",
                         op);
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
