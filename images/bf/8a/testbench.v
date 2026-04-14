`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cfg_to_turnoff;
    reg clk;
    reg compl_done_i;
    reg req_compl_i;
    reg rst_n;
    wire cfg_turnoff_ok;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cfg_to_turnoff(cfg_to_turnoff),
        .clk(clk),
        .compl_done_i(compl_done_i),
        .req_compl_i(req_compl_i),
        .rst_n(rst_n),
        .cfg_turnoff_ok(cfg_turnoff_ok)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            req_compl_i = 0;
            compl_done_i = 0;
            cfg_to_turnoff = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            cfg_to_turnoff = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            req_compl_i = 1;
            @(posedge clk);
            req_compl_i = 0;
            cfg_to_turnoff = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            req_compl_i = 1;
            @(posedge clk);
            req_compl_i = 0;
            compl_done_i = 1;
            @(posedge clk);
            compl_done_i = 0;
            cfg_to_turnoff = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            cfg_to_turnoff = 1;
            @(posedge clk);
            req_compl_i = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            cfg_to_turnoff = 1;
            req_compl_i = 1;
            @(posedge clk);
            req_compl_i = 0;
            @(posedge clk);
            compl_done_i = 1;
            @(posedge clk);
            compl_done_i = 0;
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
        input expected_cfg_turnoff_ok;
        begin
            if (expected_cfg_turnoff_ok === (expected_cfg_turnoff_ok ^ cfg_turnoff_ok ^ expected_cfg_turnoff_ok)) begin
                $display("PASS");
                $display("  Outputs: cfg_turnoff_ok=%b",
                         cfg_turnoff_ok);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cfg_turnoff_ok=%b",
                         expected_cfg_turnoff_ok);
                $display("  Got:      cfg_turnoff_ok=%b",
                         cfg_turnoff_ok);
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
        $dumpvars(0,cfg_to_turnoff, clk, compl_done_i, req_compl_i, rst_n, cfg_turnoff_ok);
    end

endmodule
