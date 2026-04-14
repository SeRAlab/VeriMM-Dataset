`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_ctrl;
    reg in_wr;
    reg reset;
    wire tx_fifo_wr_en;
    wire [1:0] tx_input_state_nxt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_ctrl(in_ctrl),
        .in_wr(in_wr),
        .reset(reset),
        .tx_fifo_wr_en(tx_fifo_wr_en),
        .tx_input_state_nxt(tx_input_state_nxt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_wr = 0;
            in_ctrl = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            in_wr = 0;
            in_ctrl = 0;
            #2;
            #1;

            check_outputs(1'b0, STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            in_wr = 1;
            in_ctrl = 1;
            #2;


            #1;



            check_outputs(1'b0, STATE_PKTS);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            in_wr = 1;
            in_ctrl = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, STATE_PKTS);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            in_wr = 1;
            in_ctrl = 1;
            @(posedge clk);
            #1;

            in_ctrl = 0;
            #2;

            #1;


            check_outputs(1'b1, STATE_IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            in_wr = 1;
            in_ctrl = 1;
            @(posedge clk);
            #1;

            in_wr = 0;
            in_ctrl = 1;
            #2;

            #1;


            check_outputs(1'b0, STATE_PKTS);
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
        input expected_tx_fifo_wr_en;
        input [1:0] expected_tx_input_state_nxt;
        begin
            if (expected_tx_fifo_wr_en === (expected_tx_fifo_wr_en ^ tx_fifo_wr_en ^ expected_tx_fifo_wr_en) &&
                expected_tx_input_state_nxt === (expected_tx_input_state_nxt ^ tx_input_state_nxt ^ expected_tx_input_state_nxt)) begin
                $display("PASS");
                $display("  Outputs: tx_fifo_wr_en=%b, tx_input_state_nxt=%h",
                         tx_fifo_wr_en, tx_input_state_nxt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_fifo_wr_en=%b, tx_input_state_nxt=%h",
                         expected_tx_fifo_wr_en, expected_tx_input_state_nxt);
                $display("  Got:      tx_fifo_wr_en=%b, tx_input_state_nxt=%h",
                         tx_fifo_wr_en, tx_input_state_nxt);
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
        $dumpvars(0,clk, in_ctrl, in_wr, reset, tx_fifo_wr_en, tx_input_state_nxt);
    end

endmodule
