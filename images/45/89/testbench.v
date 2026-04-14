`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg d;
    reg en;
    reg in0;
    reg in1;
    reg pr;
    reg sel;
    wire out;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .d(d),
        .en(en),
        .in0(in0),
        .in1(in1),
        .pr(pr),
        .sel(sel),
        .out(out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            pr = 0;
            d = 0;
            en = 0;
            sel = 0;
            in0 = 0;
            in1 = 0;
            #15;
            clr = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Async Clear");
            reset_dut();

            pr = 1; #10;

            clr = 1; pr = 0; #10;

            sel = 0; in0 = 1; in1 = 0;
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Async Preset");
            reset_dut();
            pr = 1; clr = 0; #10;

            sel = 1; in0 = 1; in1 = 0;
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sync Load High");
            reset_dut();
            en = 1; d = 1;
            @(posedge clk);
            #2;
            sel = 0; in0 = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Sync Load Low");
            reset_dut();

            pr = 1; #10; pr = 0;
            en = 1; d = 0;
            @(posedge clk);
            #2;
            sel = 1; in1 = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Enable Hold");
            reset_dut();

            en = 1; d = 1;
            @(posedge clk); #2;

            en = 0; d = 0;
            @(posedge clk); #2;
            sel = 0; in0 = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Mux Select 0");
            reset_dut();
            sel = 0; in0 = 1; in1 = 0;
            #5;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Mux Select 1");
            reset_dut();
            sel = 1; in0 = 1; in1 = 0;
            #5;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Async Priority");
            reset_dut();
            clr = 1; pr = 1; #10;
            sel = 0; in0 = 0;
            #2;

            #1;


            check_outputs(0, 0);
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
        input expected_out;
        input expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%b, q=%b",
                         out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, q=%b",
                         expected_out, expected_q);
                $display("  Got:      out=%b, q=%b",
                         out, q);
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
        $dumpvars(0,clk, clr, d, en, in0, in1, pr, sel, out, q);
    end

endmodule
