`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [39:0] blk_in;
    reg clear;
    reg load;
    reg sclk;
    reg shift_enable;
    wire [39:0] blk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blk_in(blk_in),
        .clear(clear),
        .load(load),
        .sclk(sclk),
        .shift_enable(shift_enable),
        .blk_out(blk_out)
    );

    // Clock generation (10ns period)
    initial begin
        sclk = 0;
        forever #5 sclk = ~sclk;
    end

        task reset_dut;

        begin
            clear = 1;
            load = 0;
            shift_enable = 0;
            blk_in = 0;
            @(posedge sclk);
            #1;
            clear = 0;
            @(posedge sclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 40-bit value", test_num);
            reset_dut();
            blk_in = 40'hABCDE12345;
            load = 1;
            @(posedge sclk);
            #1;
            load = 0;
            #1;

            check_outputs(40'hABCDE12345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear priority over Load", test_num);
            reset_dut();
            blk_in = 40'hFFFFFFFFFF;
            load = 1;
            clear = 1;
            @(posedge sclk);
            #1;
            #1;

            check_outputs(40'h0000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 8-bits", test_num);
            reset_dut();

            blk_in = 40'h0011223344;
            load = 1;
            @(posedge sclk);
            #1;
            load = 0;
            shift_enable = 1;
            @(posedge sclk);
            #1;
            shift_enable = 0;

            #1;


            check_outputs(40'h1122334400);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Shift Cycles", test_num);
            reset_dut();
            blk_in = 40'h00000000FF;
            load = 1;
            @(posedge sclk);
            #1;
            load = 0;
            shift_enable = 1;
            repeat(3) @(posedge sclk);
            #1;
            shift_enable = 0;

            #1;


            check_outputs(40'h00FF000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load priority over Shift", test_num);
            reset_dut();
            blk_in = 40'h5555555555;
            load = 1;
            shift_enable = 1;
            @(posedge sclk);
            #1;
            #1;

            check_outputs(40'h5555555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data retention (no enable)", test_num);
            reset_dut();
            blk_in = 40'hA5A5A5A5A5;
            load = 1;
            @(posedge sclk);
            #1;
            load = 0;
            shift_enable = 0;
            repeat(2) @(posedge sclk);
            #1;
            #1;

            check_outputs(40'hA5A5A5A5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift out all data", test_num);
            reset_dut();
            blk_in = 40'hFF00000000;
            load = 1;
            @(posedge sclk);
            #1;
            load = 0;
            shift_enable = 1;
            repeat(5) @(posedge sclk);
            #1;
            shift_enable = 0;
            #1;

            check_outputs(40'h0000000000);
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
        input [39:0] expected_blk_out;
        begin
            if (expected_blk_out === (expected_blk_out ^ blk_out ^ expected_blk_out)) begin
                $display("PASS");
                $display("  Outputs: blk_out=%h",
                         blk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blk_out=%h",
                         expected_blk_out);
                $display("  Got:      blk_out=%h",
                         blk_out);
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
        $dumpvars(0,blk_in, clear, load, sclk, shift_enable, blk_out);
    end

endmodule
