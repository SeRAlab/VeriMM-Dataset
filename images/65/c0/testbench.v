`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg d;
    reg reset;
    reg set;
    wire q;
    wire qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .d(d),
        .reset(reset),
        .set(set),
        .q(q),
        .qn(qn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            d = 0;
            set = 1;
            reset = 0;
            #15;
            reset = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Reset");
            reset_dut();

            set = 0;
            #10;
            set = 1;

            reset = 0;
            #10;
            reset = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Asynchronous Set");
            reset_dut();

            set = 0;
            #10;
            set = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load D=1 with CE=1");
            reset_dut();
            ce = 1;
            d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load D=0 with CE=1");
            reset_dut();

            ce = 1; d = 1;
            @(posedge clk);

            d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: CE=0 behavior");
            reset_dut();

            ce = 1; d = 1;
            @(posedge clk);

            ce = 0; d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Asynchronous Reset Priority");
            reset_dut();

            reset = 0;
            set = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
            reset = 1;
            set = 1;
            #5;
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: D change without CE active");
            reset_dut();
            ce = 0;
            d = 1;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Async Reset mid-cycle");
            reset_dut();
            ce = 1; d = 1;
            @(posedge clk);
            #2;
            #3;
            reset = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
            reset = 1;
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
        input expected_q;
        input expected_qn;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qn === (expected_qn ^ qn ^ expected_qn)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qn=%b",
                         q, qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qn=%b",
                         expected_q, expected_qn);
                $display("  Got:      q=%b, qn=%b",
                         q, qn);
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
        $dumpvars(0,ce, clk, d, reset, set, q, qn);
    end

endmodule
