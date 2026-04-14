`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg preset;
    reg reset;
    reg set;
    wire q;
    wire q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .preset(preset),
        .reset(reset),
        .set(set),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset  = 1;
            set    = 0;
            preset = 0;
            d      = 0;
            #15;
            reset  = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Async Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Async Set Check", test_num);
            reset_dut();
            set = 1;
            #5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Async Preset Check", test_num);
            reset_dut();
            preset = 1;
            #5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Sync Load D=1", test_num);
            reset_dut();
            d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Sync Load D=0", test_num);
            reset_dut();

            preset = 1; #5; preset = 0; #5;
            d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Reset Priority Over D", test_num);
            reset_dut();
            d = 1;
            reset = 1;
            #5;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Running Testcase %03d: Set Priority Over D", test_num);
            reset_dut();
            d = 0;
            @(posedge clk);
            #2;
            set = 1;
            #5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Running Testcase %03d: Reset Priority Over Set", test_num);
            reset_dut();
            set = 1;
            reset = 1;
            #5;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_q_bar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_bar === (expected_q_bar ^ q_bar ^ expected_q_bar)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_bar=%b",
                         q, q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_bar=%b",
                         expected_q, expected_q_bar);
                $display("  Got:      q=%b, q_bar=%b",
                         q, q_bar);
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
        $dumpvars(0,clk, d, preset, reset, set, q, q_bar);
    end

endmodule
