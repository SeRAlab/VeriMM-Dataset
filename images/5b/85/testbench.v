`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg baud1tick;
    reg clk;
    reg [7:0] txd_data;
    reg txd_start;
    wire txd;
    wire txd_busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baud1tick(baud1tick),
        .clk(clk),
        .txd_data(txd_data),
        .txd_start(txd_start),
        .txd(txd),
        .txd_busy(txd_busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            txd_start = 0;
            baud1tick = 0;
            txd_data = 8'h00;
            repeat (10) @(posedge clk);
        end
        endtask
    task simulate_transmission;

        input [7:0] data;
        begin
            txd_data = data;
            @(posedge clk);
            txd_start = 1;
            @(posedge clk);
            txd_start = 0;



            repeat (11) begin
                repeat (8) @(posedge clk);
                baud1tick = 1;
                @(posedge clk);
                baud1tick = 0;
            end
            repeat (5) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Transmit 0x55", test_num);
            reset_dut();
            simulate_transmission(8'h55);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Transmit 0xAA", test_num);
            reset_dut();
            simulate_transmission(8'hAA);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Transmit 0x00", test_num);
            reset_dut();
            simulate_transmission(8'h00);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Transmit 0xFF", test_num);
            reset_dut();
            simulate_transmission(8'hFF);
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
        input expected_txd;
        input expected_txd_busy;
        begin
            if (expected_txd === (expected_txd ^ txd ^ expected_txd) &&
                expected_txd_busy === (expected_txd_busy ^ txd_busy ^ expected_txd_busy)) begin
                $display("PASS");
                $display("  Outputs: txd=%b, txd_busy=%b",
                         txd, txd_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: txd=%b, txd_busy=%b",
                         expected_txd, expected_txd_busy);
                $display("  Got:      txd=%b, txd_busy=%b",
                         txd, txd_busy);
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
        $dumpvars(0,baud1tick, clk, txd_data, txd_start, txd, txd_busy);
    end

endmodule
