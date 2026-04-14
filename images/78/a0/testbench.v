`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [9:0] realy;
    reg xend;
    reg xstart;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .realy(realy),
        .xend(xend),
        .xstart(xstart),
        .q(q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing start pulse (xstart=1)", test_num);
            xstart = 0; xend = 0; realy = 10'd0;
            @(posedge clk);
            #1;
            xstart = 1;
            @(posedge clk);
            #1;
            xstart = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing end pulse (xend=1)", test_num);

            @(posedge clk);
            #1;
            xend = 1;
            @(posedge clk);
            #1;
            xend = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify q persistence after xstart", test_num);
            xstart = 1;
            @(posedge clk);
            #1;
            xstart = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify q persistence after xend", test_num);
            xend = 1;
            @(posedge clk);
            #1;
            xend = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing with realy values", test_num);
            xstart = 1;
            realy = 10'd512;
            @(posedge clk);
            #1;
            xstart = 0;
            repeat(2) @(posedge clk);
            realy = 10'd1023;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous xstart and xend pulse", test_num);
            xstart = 1;
            xend = 1;
            @(posedge clk);
            #1;
            xstart = 0;
            xend = 0;
            @(posedge clk);


            #1;



            check_outputs(q);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Rapid pulsing", test_num);
            xstart = 1; @(posedge clk); #1; xstart = 0;
            xend = 1;   @(posedge clk); #1; xend = 0;
            xstart = 1; @(posedge clk); #1; xstart = 0;
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
