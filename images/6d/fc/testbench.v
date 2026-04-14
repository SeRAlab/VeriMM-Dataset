`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg clr;
    reg ena;
    reg pre;
    reg r;
    reg s;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .ena(ena),
        .pre(pre),
        .r(r),
        .s(s),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);

        #1; clr = 0; pre = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);

        #1; clr = 0; pre = 0; ena = 1; s = 1; r = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);
        #1; clr = 0; pre = 1;
        @(posedge clk);

        #1; pre = 0; ena = 1; s = 0; r = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);

        #1; clr = 0; ena = 1; s = 1; r = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);
        #1; clr = 0; ena = 1; s = 1; r = 0;
        @(posedge clk);

        #1; s = 1; r = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);

        #1; clr = 0; ena = 0; s = 1; r = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);

        #1; clr = 1; pre = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);

        #1; clr = 0; pre = 1; ena = 1; s = 0; r = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;

        clr = 1; pre = 0; ena = 0; s = 0; r = 0;
        @(posedge clk);
        #1; clr = 0; pre = 1;
        @(posedge clk);

        #1; pre = 0; ena = 1; s = 0; r = 0;
        @(posedge clk);
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
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
