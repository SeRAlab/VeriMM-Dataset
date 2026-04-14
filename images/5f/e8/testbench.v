`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg check_en;
    reg clk;
    reg [7:0] rfr;
    reg rst;
    reg [7:0] sig;
    reg verbose_en;
    wire check;
    wire verbose;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .check_en(check_en),
        .clk(clk),
        .rfr(rfr),
        .rst(rst),
        .sig(sig),
        .verbose_en(verbose_en),
        .check(check),
        .verbose(verbose)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            check_en = 0;
            verbose_en = 0;
            sig = 0;
            rfr = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Mismatch with check_en=1");
            reset_dut();
            sig = 8'hA5;
            rfr = 8'h5A;
            check_en = 1;
            verbose_en = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Match with check_en=1");
            reset_dut();
            sig = 8'hFF;
            rfr = 8'hFF;
            check_en = 1;
            verbose_en = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Mismatch with check_en=0");
            reset_dut();
            sig = 8'h12;
            rfr = 8'h34;
            check_en = 0;
            verbose_en = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mismatch with check_en=1 and verbose_en=1");
            reset_dut();
            sig = 8'hDE;
            rfr = 8'hAD;
            check_en = 1;
            verbose_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Match with check_en=1 and verbose_en=1");
            reset_dut();
            sig = 8'h00;
            rfr = 8'h00;
            check_en = 1;
            verbose_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Verification of Reset clearing outputs");
            reset_dut();

            sig = 8'hCC;
            rfr = 8'h33;
            check_en = 1;
            verbose_en = 1;
            @(posedge clk);
            #2;

            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
            rst = 0;
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Boundary values (All 1s mismatch)");
            reset_dut();
            sig = 8'hFF;
            rfr = 8'hFE;
            check_en = 1;
            verbose_en = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_check;
        input expected_verbose;
        begin
            if (expected_check === (expected_check ^ check ^ expected_check) &&
                expected_verbose === (expected_verbose ^ verbose ^ expected_verbose)) begin
                $display("PASS");
                $display("  Outputs: check=%b, verbose=%b",
                         check, verbose);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: check=%b, verbose=%b",
                         expected_check, expected_verbose);
                $display("  Got:      check=%b, verbose=%b",
                         check, verbose);
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
        $dumpvars(0,check_en, clk, rfr, rst, sig, verbose_en, check, verbose);
    end

endmodule
