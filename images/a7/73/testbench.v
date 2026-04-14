`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg i;
    reg rst;
    wire ee;
    wire ne;
    wire pe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .i(i),
        .rst(rst),
        .ee(ee),
        .ne(ne),
        .pe(pe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ce = 0;
            i = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rising edge detection (ce=1)", test_num);
            reset_dut();
            @(negedge clk);
            ce = 1;
            i = 0;
            @(negedge clk);
            i = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Falling edge detection (ce=1)", test_num);
            reset_dut();
            @(negedge clk);
            ce = 1;
            i = 1;
            @(posedge clk);
            @(negedge clk);
            i = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rising edge with ce=0", test_num);
            reset_dut();
            @(negedge clk);
            ce = 0;
            i = 0;
            @(negedge clk);
            i = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Falling edge with ce=0", test_num);
            reset_dut();
            @(negedge clk);
            ce = 1; i = 1;
            @(posedge clk);
            @(negedge clk);
            ce = 0;
            i = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Continuous high state", test_num);
            reset_dut();
            @(negedge clk);
            ce = 1; i = 1;
            @(posedge clk);
            @(negedge clk);

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence 0-1-0 detection", test_num);
            reset_dut();
            @(negedge clk);
            ce = 1; i = 1;
            @(posedge clk);
            @(negedge clk);
            i = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable toggle during transition", test_num);
            reset_dut();
            @(negedge clk);
            ce = 0; i = 1;
            @(posedge clk);
            @(negedge clk);
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
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
        input expected_ee;
        input expected_ne;
        input expected_pe;
        begin
            if (expected_ee === (expected_ee ^ ee ^ expected_ee) &&
                expected_ne === (expected_ne ^ ne ^ expected_ne) &&
                expected_pe === (expected_pe ^ pe ^ expected_pe)) begin
                $display("PASS");
                $display("  Outputs: ee=%b, ne=%b, pe=%b",
                         ee, ne, pe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ee=%b, ne=%b, pe=%b",
                         expected_ee, expected_ne, expected_pe);
                $display("  Got:      ee=%b, ne=%b, pe=%b",
                         ee, ne, pe);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ce, clk, i, rst, ee, ne, pe);
    end

endmodule
