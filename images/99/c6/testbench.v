`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_en;
    reg [31:0] data_in;
    reg reset;
    reg start;
    reg sync;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_en(clk_en),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .sync(sync),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            clk_en = 1;
            start = 0;
            sync = 0;
            data_in = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(negedge clk);
            $display("Testcase %03d: Basic Reset", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            clk_en = 1;
            start = 1;
            sync = 1;
            data_in = 32'hDEADBEEF;
            @(negedge clk);
            $display("Testcase %03d: Load Data DEADBEEF", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(negedge clk);
            clk_en = 1; start = 1; sync = 1; data_in = 32'hAAAA_5555;
            @(negedge clk);

            clk_en = 0; start = 1; sync = 1; data_in = 32'hFFFF_FFFF;
            @(negedge clk);
            $display("Testcase %03d: Clock Enable Gating", test_num);
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clk);
            clk_en = 1; start = 1; sync = 1; data_in = 32'h1234_5678;
            @(negedge clk);

            clk_en = 1; start = 0; sync = 1; data_in = 32'hFFFF_FFFF;
            @(negedge clk);
            $display("Testcase %03d: Start Signal Gating", test_num);
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clk);
            clk_en = 1; start = 1; sync = 1; data_in = 32'hCAFE_BABE;
            @(negedge clk);

            clk_en = 1; start = 1; sync = 0; data_in = 32'hFFFF_FFFF;
            @(negedge clk);
            $display("Testcase %03d: Sync Signal Gating", test_num);
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);

            reset = 1;
            clk_en = 1;
            start = 1;
            sync = 1;
            data_in = 32'hFFFF_FFFF;
            @(negedge clk);
            $display("Testcase %03d: Reset Priority", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(negedge clk);
            clk_en = 1; start = 1; sync = 1;
            data_in = 32'h0000_0001; @(negedge clk);
            data_in = 32'h0000_0002; @(negedge clk);
            data_in = 32'h0000_0004; @(negedge clk);
            data_in = 32'h0000_0008; @(negedge clk);
            $display("Testcase %03d: Sequential Updates", test_num);
            #1;

            check_outputs(32'h0000_0008);
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, clk_en, data_in, reset, start, sync, data_out);
    end

endmodule
