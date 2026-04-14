`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_test;
    reg rst;
    reg [7:0] xgmii_txc;
    reg [63:0] xgmii_txd;
    wire [63:0] encoded_tx_data;
    wire [1:0] encoded_tx_hdr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .current_test(current_test),
        .rst(rst),
        .xgmii_txc(xgmii_txc),
        .xgmii_txd(xgmii_txd),
        .encoded_tx_data(encoded_tx_data),
        .encoded_tx_hdr(encoded_tx_hdr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_test = 0;
            xgmii_txd = 0;
            xgmii_txc = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State");
            current_test = 8'd1;
            rst = 1;
            xgmii_txd = 64'hFFFFFFFFFFFFFFFF;
            xgmii_txc = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0, 2'b00);
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Pure Data Block");
            reset_dut();
            current_test = 8'd2;
            xgmii_txd = 64'h0123456789ABCDEF;
            xgmii_txc = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0123456789ABCDEF, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Control Block (Idle)");
            reset_dut();
            current_test = 8'd3;
            xgmii_txd = 64'h0707070707070707;
            xgmii_txc = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0707070707070707, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Start of Packet");
            reset_dut();
            current_test = 8'd4;
            xgmii_txd = 64'hD5555555555555FB;
            xgmii_txc = 8'h01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hD5555555555555FB, 2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: End of Packet");
            reset_dut();
            current_test = 8'd5;
            xgmii_txd = 64'h070707FD00112233;
            xgmii_txc = 8'hF0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h070707FD00112233, 2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Alternating Patterns");
            reset_dut();
            current_test = 8'd6;
            xgmii_txd = 64'hAAAAAAAAAAAAAAAA;
            xgmii_txc = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA, 2'b01);

            xgmii_txd = 64'h5555555555555555;
            xgmii_txc = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h5555555555555555, 2'b10);
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
        input [63:0] expected_encoded_tx_data;
        input [1:0] expected_encoded_tx_hdr;
        begin
            if (expected_encoded_tx_data === (expected_encoded_tx_data ^ encoded_tx_data ^ expected_encoded_tx_data) &&
                expected_encoded_tx_hdr === (expected_encoded_tx_hdr ^ encoded_tx_hdr ^ expected_encoded_tx_hdr)) begin
                $display("PASS");
                $display("  Outputs: encoded_tx_data=%h, encoded_tx_hdr=%h",
                         encoded_tx_data, encoded_tx_hdr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_tx_data=%h, encoded_tx_hdr=%h",
                         expected_encoded_tx_data, expected_encoded_tx_hdr);
                $display("  Got:      encoded_tx_data=%h, encoded_tx_hdr=%h",
                         encoded_tx_data, encoded_tx_hdr);
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
        $dumpvars(0,clk, current_test, rst, xgmii_txc, xgmii_txd, encoded_tx_data, encoded_tx_hdr);
    end

endmodule
