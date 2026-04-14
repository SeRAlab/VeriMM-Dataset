`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [42:0] a_V;
    reg add;
    reg [42:0] b_V;
    wire ap_ready;
    wire [43:0] ap_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_V(a_V),
        .add(add),
        .b_V(b_V),
        .ap_ready(ap_ready),
        .ap_return(ap_return)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive Addition (100 + 200)", test_num);
        a_V = 43'sd100;
        b_V = 43'sd200;
        add = 1'b1;
        #1;

        check_outputs(1'b1, 44'sd300);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive Subtraction (500 - 150)", test_num);
        a_V = 43'sd500;
        b_V = 43'sd150;
        add = 1'b0;
        #1;

        check_outputs(1'b1, 44'sd350);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Addition (-100 + -200)", test_num);
        a_V = -43'sd100;
        b_V = -43'sd200;
        add = 1'b1;
        #1;

        check_outputs(1'b1, -44'sd300);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative result Subtraction (10 - 50)", test_num);
        a_V = 43'sd10;
        b_V = 43'sd50;
        add = 1'b0;
        #1;

        check_outputs(1'b1, -44'sd40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Case - Max Positive Sum", test_num);
        a_V = 43'h3FFFFFFFFFF;
        b_V = 43'h3FFFFFFFFFF;
        add = 1'b1;
        #1;

        check_outputs(1'b1, 44'h3FFFFFFFFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Case - Max Negative Sum", test_num);
        a_V = 43'h40000000000;
        b_V = 43'h40000000000;
        add = 1'b1;
        #1;

        check_outputs(1'b1, 44'h200000000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Case - Max Positive Difference", test_num);
        a_V = 43'h3FFFFFFFFFF;
        b_V = 43'h40000000000;
        add = 1'b0;
        #1;

        check_outputs(1'b1, 44'h3FFFFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Case - Max Negative Difference", test_num);
        a_V = 43'h40000000000;
        b_V = 43'h3FFFFFFFFFF;
        add = 1'b0;
        #1;

        check_outputs(1'b1, 44'h200000000001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Case", test_num);
        a_V = 43'd0;
        b_V = 43'd0;
        add = 1'b1;
        #1;

        check_outputs(1'b1, 44'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Sign Subtraction (-50 - 50)", test_num);
        a_V = -43'sd50;
        b_V = 43'sd50;
        add = 1'b0;
        #1;

        check_outputs(1'b1, -44'sd100);
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
        input expected_ap_ready;
        input [43:0] expected_ap_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ap_ready === (expected_ap_ready ^ ap_ready ^ expected_ap_ready) &&
                expected_ap_return === (expected_ap_return ^ ap_return ^ expected_ap_return)) begin
                $display("PASS");
                $display("  Outputs: ap_ready=%b, ap_return=%h",
                         ap_ready, ap_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ap_ready=%b, ap_return=%h",
                         expected_ap_ready, expected_ap_return);
                $display("  Got:      ap_ready=%b, ap_return=%h",
                         ap_ready, ap_return);
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
