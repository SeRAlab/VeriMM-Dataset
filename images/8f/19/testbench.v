`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [5:0] rx_address;
    wire [31:0] tx_k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rx_address(rx_address),
        .tx_k(tx_k)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Address 0x00 (Expected: 428a2f98)");

        rx_address = 6'h00;
        @(posedge clk);

        #1;


        check_outputs(32'h428a2f98);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Address 0x01 (Expected: 71374491)");
        rx_address = 6'h01;
        @(posedge clk);
        #1;

        check_outputs(32'h71374491);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Address 0x0F (Expected: c19bf174)");
        rx_address = 6'h0F;
        @(posedge clk);
        #1;

        check_outputs(32'hc19bf174);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Address 0x1F (Expected: 14292967)");
        rx_address = 6'h1F;
        @(posedge clk);
        #1;

        check_outputs(32'h14292967);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Address 0x20 (Expected: 27b70a85)");
        rx_address = 6'h20;
        @(posedge clk);
        #1;

        check_outputs(32'h27b70a85);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Address 0x3F (Expected: c67178f2)");
        rx_address = 6'h3F;
        @(posedge clk);
        #1;

        check_outputs(32'hc67178f2);
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
        input [31:0] expected_tx_k;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tx_k === (expected_tx_k ^ tx_k ^ expected_tx_k)) begin
                $display("PASS");
                $display("  Outputs: tx_k=%h",
                         tx_k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_k=%h",
                         expected_tx_k);
                $display("  Got:      tx_k=%h",
                         tx_k);
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
