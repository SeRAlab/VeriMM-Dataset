`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [2:0] cnt0_out;
    wire [1:0] sel_sig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .cnt0_out(cnt0_out),
        .sel_sig(sel_sig)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task wait_cycles;

        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) begin
                @(posedge clk);
            end
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(3'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter = 1", test_num);
            reset_dut();
            wait_cycles(1);

            #1;


            check_outputs(3'd1, 2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter = 2", test_num);
            reset_dut();
            wait_cycles(2);

            #1;


            check_outputs(3'd2, 2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter = 3", test_num);
            reset_dut();
            wait_cycles(3);

            #1;


            check_outputs(3'd3, 2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter = 4", test_num);
            reset_dut();
            wait_cycles(4);

            #1;


            check_outputs(3'd4, 2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter = 5", test_num);
            reset_dut();
            wait_cycles(5);

            #1;


            check_outputs(3'd5, 2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wrap around check (6 cycles -> Counter 0)", test_num);
            reset_dut();
            wait_cycles(6);

            #1;


            check_outputs(3'd0, 2'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wrap around check (7 cycles -> Counter 1)", test_num);
            reset_dut();
            wait_cycles(7);

            #1;


            check_outputs(3'd1, 2'd0);
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
        input [2:0] expected_cnt0_out;
        input [1:0] expected_sel_sig;
        begin
            if (expected_cnt0_out === (expected_cnt0_out ^ cnt0_out ^ expected_cnt0_out) &&
                expected_sel_sig === (expected_sel_sig ^ sel_sig ^ expected_sel_sig)) begin
                $display("PASS");
                $display("  Outputs: cnt0_out=%h, sel_sig=%h",
                         cnt0_out, sel_sig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt0_out=%h, sel_sig=%h",
                         expected_cnt0_out, expected_sel_sig);
                $display("  Got:      cnt0_out=%h, sel_sig=%h",
                         cnt0_out, sel_sig);
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
        $dumpvars(0,clk, rst_n, cnt0_out, sel_sig);
    end

endmodule
