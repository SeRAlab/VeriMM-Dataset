`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg rst;
    wire [3:0] q;
    wire [3:0] q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .load(load),
        .rst(rst),
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
            rst = 1;
            en = 0;
            load = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Basic Counting", test_num);
            reset_dut();
            en = 1;
            repeat(4) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'h4, 4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Enable Gating", test_num);
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1 en = 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(4'h2, 4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Load (Inversion)", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1 en = 0; load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'hA, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Load and Enable simultaneous", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            #1 load = 1; en = 1;
            @(posedge clk);
            #1 load = 0; en = 0;
            #1;

            check_outputs(4'hC, 4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Wrap-around logic", test_num);
            reset_dut();
            en = 1;
            repeat(16) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Running Testcase %03d: Consecutive Load/Toggles", test_num);
            reset_dut();
            #1 load = 1;
            @(posedge clk);
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'h0, 4'hF);
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
        input [3:0] expected_q;
        input [3:0] expected_q_bar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_bar === (expected_q_bar ^ q_bar ^ expected_q_bar)) begin
                $display("PASS");
                $display("  Outputs: q=%h, q_bar=%h",
                         q, q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, q_bar=%h",
                         expected_q, expected_q_bar);
                $display("  Got:      q=%h, q_bar=%h",
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
        $dumpvars(0,clk, en, load, rst, q, q_bar);
    end

endmodule
