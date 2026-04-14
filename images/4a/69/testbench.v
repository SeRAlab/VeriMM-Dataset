`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg i;
    reg rst;
    wire o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i(i),
        .rst(rst),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Asynchronous load '1' (negedge rst)");

            clk = 0;
            i = 1;
            rst = 1;
            #10;

            rst = 0;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Asynchronous load '0' (negedge rst)");

            clk = 0;
            i = 0;
            rst = 1;
            #10;

            rst = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Synchronous capture '1' (posedge clk)");

            i = 0; rst = 1; #5; rst = 0; #5; rst = 1; #10;

            i = 1;
            clk = 0;
            #10;

            clk = 1;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Synchronous capture '0' (posedge clk)");

            i = 1; rst = 1; #5; rst = 0; #5; rst = 1; #10;

            i = 0;
            clk = 0;
            #10;

            clk = 1;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Data Retention (No edge activity)");

            i = 1; rst = 1; #5; rst = 0; #5; rst = 1; #10;

            i = 0;
            clk = 0;
            #20;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Asynchronous reset priority");

            clk = 0; rst = 1; i = 0; #10;

            i = 1;
            #2;
            rst = 0;
            #2;
            clk = 1;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcases1;

        begin
            testcase001();
            testcase002();
            testcase003();
        end
        endtask

    task testcases2;

        begin
            testcase004();
            testcase005();
            testcase006();
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
        testcases1();
        testcases2();
        
        
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
        input expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%b",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b",
                         expected_o);
                $display("  Got:      o=%b",
                         o);
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
