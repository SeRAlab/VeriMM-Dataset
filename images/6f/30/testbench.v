`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] i_acc;
    reg i_op;
    reg [15:0] i_selB;
    wire [15:0] o_2selA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_acc(i_acc),
        .i_op(i_op),
        .i_selB(i_selB),
        .o_2selA(o_2selA)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition (10 + 20)", test_num);
        i_op = 1'b1;
        i_selB = 16'd10;
        i_acc = 16'd20;
        #1;

        check_outputs(16'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Subtraction (20 - 10)", test_num);
        i_op = 1'b0;
        i_selB = 16'd10;
        i_acc = 16'd20;
        #1;

        check_outputs(16'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Addition Overflow (0xFFFF + 1)", test_num);
        i_op = 1'b1;
        i_selB = 16'hFFFF;
        i_acc = 16'h0001;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Subtraction Underflow (0 - 1)", test_num);
        i_op = 1'b0;
        i_selB = 16'h0001;
        i_acc = 16'h0000;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Addition with Zero", test_num);
        i_op = 1'b1;
        i_selB = 16'hABCD;
        i_acc = 16'h0000;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Subtraction resulting in Zero", test_num);
        i_op = 1'b0;
        i_selB = 16'h5555;
        i_acc = 16'h5555;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Large Number Addition", test_num);
        i_op = 1'b1;
        i_selB = 16'h1234;
        i_acc = 16'h4321;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Large Number Subtraction", test_num);
        i_op = 1'b0;
        i_selB = 16'h1000;
        i_acc = 16'hF000;
        #1;

        check_outputs(16'hE000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Addition All Ones", test_num);
        i_op = 1'b1;
        i_selB = 16'hFFFF;
        i_acc = 16'hFFFF;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Subtraction All Ones", test_num);
        i_op = 1'b0;
        i_selB = 16'hFFFF;
        i_acc = 16'hFFFF;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_o_2selA;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_2selA === (expected_o_2selA ^ o_2selA ^ expected_o_2selA)) begin
                $display("PASS");
                $display("  Outputs: o_2selA=%h",
                         o_2selA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_2selA=%h",
                         expected_o_2selA);
                $display("  Got:      o_2selA=%h",
                         o_2selA);
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
