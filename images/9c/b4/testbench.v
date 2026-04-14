`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in_clk;
    wire out_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_clk(in_clk),
        .out_clk(out_clk)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Low", test_num);
        in_clk = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input High", test_num);
        in_clk = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Rising Edge Transition", test_num);
        in_clk = 1'b0;
        #5;
        in_clk = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Falling Edge Transition", test_num);
        in_clk = 1'b1;
        #5;
        in_clk = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple Toggles", test_num);
        in_clk = 1'b0;
        #2 in_clk = 1'b1;
        #2 in_clk = 1'b0;
        #2 in_clk = 1'b1;
        #2 in_clk = 1'b0;
        #2 in_clk = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
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
        input expected_out_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk)) begin
                $display("PASS");
                $display("  Outputs: out_clk=%b",
                         out_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_clk=%b",
                         expected_out_clk);
                $display("  Got:      out_clk=%b",
                         out_clk);
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
