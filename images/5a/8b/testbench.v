`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ce;
    reg clk;
    reg clr;
    reg d0;
    reg d1;
    reg sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .d0(d0),
        .d1(d1),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Synchronous Clear");

            clr = 1; ce = 1; sel = 0; d0 = 1; d1 = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Select d0 (sel=0, d0=1)");

            clr = 1;
            @(posedge clk);

            clr = 0; ce = 1; sel = 0; d0 = 1; d1 = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Select d1 (sel=1, d1=1)");

            clr = 1;
            @(posedge clk);

            clr = 0; ce = 1; sel = 1; d0 = 0; d1 = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Clock Enable (ce=0) hold value");

            clr = 1;
            @(posedge clk);

            clr = 0; ce = 1; sel = 0; d0 = 1; d1 = 0;
            @(posedge clk);
            #1;


            ce = 0; sel = 1; d1 = 0; d0 = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Clear priority over Data");

            clr = 1;
            @(posedge clk);

            clr = 0; ce = 1; sel = 0; d0 = 1;
            @(posedge clk);
            #1;


            clr = 1; ce = 1; d0 = 1; d1 = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Clear priority over Clock Enable");

            clr = 1;
            @(posedge clk);

            clr = 0; ce = 1; sel = 0; d0 = 1;
            @(posedge clk);
            #1;


            clr = 1; ce = 0; d0 = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Toggle data input d0");

            clr = 1;
            @(posedge clk);

            clr = 0; ce = 1; sel = 0; d0 = 0;
            @(posedge clk);
            #1;


            d0 = 1;
            @(posedge clk);

            #1;
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
