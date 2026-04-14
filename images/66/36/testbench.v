`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] dac_data_0_0;
    reg [15:0] dac_data_0_1;
    reg [15:0] dac_data_0_2;
    reg [15:0] dac_data_0_3;
    reg [15:0] dac_data_1_0;
    reg [15:0] dac_data_1_1;
    reg [15:0] dac_data_1_2;
    reg [15:0] dac_data_1_3;
    reg dac_rst;
    reg tx_clk;
    wire dac_clk;
    wire [127:0] tx_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dac_data_0_0(dac_data_0_0),
        .dac_data_0_1(dac_data_0_1),
        .dac_data_0_2(dac_data_0_2),
        .dac_data_0_3(dac_data_0_3),
        .dac_data_1_0(dac_data_1_0),
        .dac_data_1_1(dac_data_1_1),
        .dac_data_1_2(dac_data_1_2),
        .dac_data_1_3(dac_data_1_3),
        .dac_rst(dac_rst),
        .tx_clk(tx_clk),
        .dac_clk(dac_clk),
        .tx_data(tx_data)
    );

        task reset_dut;

    begin
        dac_rst = 1;
        dac_data_0_0 = 16'h0;
        dac_data_0_1 = 16'h0;
        dac_data_0_2 = 16'h0;
        dac_data_0_3 = 16'h0;
        dac_data_1_0 = 16'h0;
        dac_data_1_1 = 16'h0;
        dac_data_1_2 = 16'h0;
        dac_data_1_3 = 16'h0;
        repeat(2) @(posedge tx_clk);
        #1 dac_rst = 0;
        @(posedge tx_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        dac_rst = 1;
        dac_data_0_0 = 16'hAAAA;
        dac_data_1_3 = 16'h5555;
        @(posedge tx_clk);
        #2;
        $display("Testcase 001: Checking Reset State...");
        #1;

        check_outputs(1'b1, 128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        dac_rst = 0;
        dac_data_0_0 = 16'h0001;
        dac_data_0_1 = 16'h0002;
        dac_data_0_2 = 16'h0003;
        dac_data_0_3 = 16'h0004;
        dac_data_1_0 = 16'h0005;
        dac_data_1_1 = 16'h0006;
        dac_data_1_2 = 16'h0007;
        dac_data_1_3 = 16'h0008;
        @(posedge tx_clk);
        #2;
        $display("Testcase 002: Checking Data Packing (Incrementing Pattern)...");
        #1;

        check_outputs(1'b1, 128'h0008_0007_0006_0005_0004_0003_0002_0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        dac_rst = 0;
        dac_data_0_0 = 16'hFFFF; dac_data_0_1 = 16'hFFFF;
        dac_data_0_2 = 16'hFFFF; dac_data_0_3 = 16'hFFFF;
        dac_data_1_0 = 16'hFFFF; dac_data_1_1 = 16'hFFFF;
        dac_data_1_2 = 16'hFFFF; dac_data_1_3 = 16'hFFFF;
        @(posedge tx_clk);
        #2;
        $display("Testcase 003: Checking All Bits High...");
        #1;

        check_outputs(1'b1, 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        dac_rst = 0;
        dac_data_0_0 = 16'hA5A5; dac_data_0_1 = 16'h5A5A;
        dac_data_0_2 = 16'hA5A5; dac_data_0_3 = 16'h5A5A;
        dac_data_1_0 = 16'hA5A5; dac_data_1_1 = 16'h5A5A;
        dac_data_1_2 = 16'hA5A5; dac_data_1_3 = 16'h5A5A;
        @(posedge tx_clk);
        #2;
        $display("Testcase 004: Checking Alternating Byte Patterns...");
        #1;

        check_outputs(1'b1, 128'h5A5A_A5A5_5A5A_A5A5_5A5A_A5A5_5A5A_A5A5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        dac_rst = 0;
        dac_data_0_0 = 16'h1234; dac_data_0_1 = 16'h0000;
        dac_data_0_2 = 16'h0000; dac_data_0_3 = 16'h0000;
        dac_data_1_0 = 16'h0000; dac_data_1_1 = 16'h0000;
        dac_data_1_2 = 16'h0000; dac_data_1_3 = 16'hABCD;
        @(posedge tx_clk);
        #2;
        $display("Testcase 005: Checking Channel Alignment (MSB/LSB channels)...");
        #1;

        check_outputs(1'b1, 128'hABCD_0000_0000_0000_0000_0000_0000_1234);
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
        input expected_dac_clk;
        input [127:0] expected_tx_data;
        begin
            if (expected_dac_clk === (expected_dac_clk ^ dac_clk ^ expected_dac_clk) &&
                expected_tx_data === (expected_tx_data ^ tx_data ^ expected_tx_data)) begin
                $display("PASS");
                $display("  Outputs: dac_clk=%b, tx_data=%h",
                         dac_clk, tx_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_clk=%b, tx_data=%h",
                         expected_dac_clk, expected_tx_data);
                $display("  Got:      dac_clk=%b, tx_data=%h",
                         dac_clk, tx_data);
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
        $dumpvars(0,dac_data_0_0, dac_data_0_1, dac_data_0_2, dac_data_0_3, dac_data_1_0, dac_data_1_1, dac_data_1_2, dac_data_1_3, dac_rst, tx_clk, dac_clk, tx_data);
    end

endmodule
