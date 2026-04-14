`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg channelizer_512_sysce;
    reg channelizer_512_sysclk;
    reg channelizer_512_sysclr;
    wire channelizer_512_ce1;
    wire channelizer_512_clk1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channelizer_512_sysce(channelizer_512_sysce),
        .channelizer_512_sysclk(channelizer_512_sysclk),
        .channelizer_512_sysclr(channelizer_512_sysclr),
        .channelizer_512_ce1(channelizer_512_ce1),
        .channelizer_512_clk1(channelizer_512_clk1)
    );

    // Clock generation (10ns period)
    initial begin
        channelizer_512_sysclk = 0;
        forever #5 channelizer_512_sysclk = ~channelizer_512_sysclk;
    end

        task reset_dut;

        begin
            channelizer_512_sysce = 0;
            channelizer_512_sysclr = 1;
            @(posedge channelizer_512_sysclk);
            #1;
            channelizer_512_sysclr = 0;
            @(posedge channelizer_512_sysclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Post-Reset Idle State");
            reset_dut();
            channelizer_512_sysce = 0;
            channelizer_512_sysclr = 0;
            repeat(2) @(posedge channelizer_512_sysclk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Enable Active Operation");
            reset_dut();
            channelizer_512_sysce = 1;
            channelizer_512_sysclr = 0;

            repeat(5) @(posedge channelizer_512_sysclk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Clear Signal Dominance");
            reset_dut();
            channelizer_512_sysce = 1;
            channelizer_512_sysclr = 0;
            repeat(3) @(posedge channelizer_512_sysclk);

            channelizer_512_sysclr = 1;
            repeat(2) @(posedge channelizer_512_sysclk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Disabling System Enable");
            reset_dut();
            channelizer_512_sysce = 1;
            repeat(5) @(posedge channelizer_512_sysclk);

            channelizer_512_sysce = 0;
            repeat(5) @(posedge channelizer_512_sysclk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Rapid SysCE Toggle");
            reset_dut();
            channelizer_512_sysce = 1;
            @(posedge channelizer_512_sysclk);
            #1 channelizer_512_sysce = 0;
            @(posedge channelizer_512_sysclk);
            #1 channelizer_512_sysce = 1;
            repeat(2) @(posedge channelizer_512_sysclk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
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
        input expected_channelizer_512_ce1;
        input expected_channelizer_512_clk1;
        begin
            if (expected_channelizer_512_ce1 === (expected_channelizer_512_ce1 ^ channelizer_512_ce1 ^ expected_channelizer_512_ce1) &&
                expected_channelizer_512_clk1 === (expected_channelizer_512_clk1 ^ channelizer_512_clk1 ^ expected_channelizer_512_clk1)) begin
                $display("PASS");
                $display("  Outputs: channelizer_512_ce1=%b, channelizer_512_clk1=%b",
                         channelizer_512_ce1, channelizer_512_clk1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channelizer_512_ce1=%b, channelizer_512_clk1=%b",
                         expected_channelizer_512_ce1, expected_channelizer_512_clk1);
                $display("  Got:      channelizer_512_ce1=%b, channelizer_512_clk1=%b",
                         channelizer_512_ce1, channelizer_512_clk1);
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
        $dumpvars(0,channelizer_512_sysce, channelizer_512_sysclk, channelizer_512_sysclr, channelizer_512_ce1, channelizer_512_clk1);
    end

endmodule
