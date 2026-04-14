`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_i;
    reg ena_i;
    reg rst_i;
    reg strobe_i;
    reg [13:0] tx_i_i;
    reg [13:0] tx_q_i;
    wire [13:0] tx_data_o;
    wire tx_sync_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .ena_i(ena_i),
        .rst_i(rst_i),
        .strobe_i(strobe_i),
        .tx_i_i(tx_i_i),
        .tx_q_i(tx_q_i),
        .tx_data_o(tx_data_o),
        .tx_sync_o(tx_sync_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset Check", test_num);
        rst_i = 1;
        ena_i = 0;
        strobe_i = 0;
        tx_i_i = 14'h3FFF;
        tx_q_i = 14'h3FFF;
        @(posedge clk_i);
        #1 rst_i = 0;
        @(posedge clk_i);
        #1;

        check_outputs(14'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: I-component Check", test_num);
        rst_i = 1;
        @(posedge clk_i);
        #1 rst_i = 0;
        ena_i = 1;
        strobe_i = 1;
        tx_i_i = 14'h1234;
        tx_q_i = 14'h2345;
        @(posedge clk_i);

        #1;


        check_outputs(14'h1234, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Q-component Check", test_num);
        rst_i = 1;
        @(posedge clk_i);
        #1 rst_i = 0;
        ena_i = 1;
        strobe_i = 1;
        tx_i_i = 14'h1AAA;
        tx_q_i = 14'h2BBB;
        @(posedge clk_i);
        #1 strobe_i = 0;
        @(posedge clk_i);
        #1;

        check_outputs(14'h2BBB, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Enable Signal Check", test_num);
        rst_i = 1;
        @(posedge clk_i);
        #1 rst_i = 0;
        ena_i = 0;
        strobe_i = 1;
        tx_i_i = 14'h3FFF;
        tx_q_i = 14'h3FFF;
        @(posedge clk_i);
        #1;

        check_outputs(14'h0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Strobe Signal Check", test_num);
        rst_i = 1;
        @(posedge clk_i);
        #1 rst_i = 0;
        ena_i = 1;
        strobe_i = 0;
        tx_i_i = 14'h2222;
        tx_q_i = 14'h3333;
        @(posedge clk_i);

        #1;


        check_outputs(14'h0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Back-to-Back Frame Check", test_num);
        rst_i = 1;
        @(posedge clk_i);
        #1 rst_i = 0;
        ena_i = 1;
        strobe_i = 1;
        tx_i_i = 14'h0001; tx_q_i = 14'h0002;
        @(posedge clk_i);
        #1 tx_i_i = 14'h0003; tx_q_i = 14'h0004;
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(14'h0002, 1'b0);
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
        input [13:0] expected_tx_data_o;
        input expected_tx_sync_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tx_data_o === (expected_tx_data_o ^ tx_data_o ^ expected_tx_data_o) &&
                expected_tx_sync_o === (expected_tx_sync_o ^ tx_sync_o ^ expected_tx_sync_o)) begin
                $display("PASS");
                $display("  Outputs: tx_data_o=%h, tx_sync_o=%b",
                         tx_data_o, tx_sync_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_data_o=%h, tx_sync_o=%b",
                         expected_tx_data_o, expected_tx_sync_o);
                $display("  Got:      tx_data_o=%h, tx_sync_o=%b",
                         tx_data_o, tx_sync_o);
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

endmodule
