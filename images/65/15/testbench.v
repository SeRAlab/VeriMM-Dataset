`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [7:0] rx_i;
    reg rx_i_v;
    wire tx_o;
    wire tx_o_v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .rx_i(rx_i),
        .rx_i_v(rx_i_v),
        .tx_o(tx_o),
        .tx_o_v(tx_o_v)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rx_i = 8'h00;
            rx_i_v = 0;
            repeat(2) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 8'h55 (Alternating 01010101)", test_num);
            reset_dut();
            rx_i = 8'h55;
            rx_i_v = 1;
            @(posedge clk_i);
            rx_i_v = 0;

            repeat(10) @(posedge clk_i);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 8'hAA (Alternating 10101010)", test_num);
            reset_dut();
            rx_i = 8'hAA;
            rx_i_v = 1;
            @(posedge clk_i);
            rx_i_v = 0;
            repeat(10) @(posedge clk_i);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 8'h00", test_num);
            reset_dut();
            rx_i = 8'h00;
            rx_i_v = 1;
            @(posedge clk_i);
            rx_i_v = 0;
            repeat(10) @(posedge clk_i);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 8'hFF", test_num);
            reset_dut();
            rx_i = 8'hFF;
            rx_i_v = 1;
            @(posedge clk_i);
            rx_i_v = 0;
            repeat(10) @(posedge clk_i);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data 8'hA5", test_num);
            reset_dut();
            rx_i = 8'hA5;
            rx_i_v = 1;
            @(posedge clk_i);
            rx_i_v = 0;
            repeat(10) @(posedge clk_i);
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
        input expected_tx_o;
        input expected_tx_o_v;
        begin
            if (expected_tx_o === (expected_tx_o ^ tx_o ^ expected_tx_o) &&
                expected_tx_o_v === (expected_tx_o_v ^ tx_o_v ^ expected_tx_o_v)) begin
                $display("PASS");
                $display("  Outputs: tx_o=%b, tx_o_v=%b",
                         tx_o, tx_o_v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_o=%b, tx_o_v=%b",
                         expected_tx_o, expected_tx_o_v);
                $display("  Got:      tx_o=%b, tx_o_v=%b",
                         tx_o, tx_o_v);
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
        $dumpvars(0,clk_i, rx_i, rx_i_v, tx_o, tx_o_v);
    end

endmodule
