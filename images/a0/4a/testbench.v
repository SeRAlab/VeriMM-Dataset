`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rx_clk;
    reg [31:0] rx_ip_data;
    reg [3:0] rx_ip_sof;
    wire [31:0] rx_data;
    wire rx_sof;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx_clk(rx_clk),
        .rx_ip_data(rx_ip_data),
        .rx_ip_sof(rx_ip_sof),
        .rx_data(rx_data),
        .rx_sof(rx_sof)
    );

    // Clock generation (10ns period)
    initial begin
        rx_clk = 0;
        forever #5 rx_clk = ~rx_clk;
    end

        task reset_dut;

    begin
        rx_ip_data <= 32'h0;
        rx_ip_sof  <= 4'h0;
        repeat(5) @(posedge rx_clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: SOF at Byte 3 (Offset 0)", test_num);

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b1000;
        rx_ip_data <= 32'h11223344;

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b0000;
        rx_ip_data <= 32'h55667788;

        repeat(2) @(posedge rx_clk);
        #1;
        #1;

        check_outputs(32'h11223344, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: SOF at Byte 2 (Offset 1)", test_num);

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b0100;
        rx_ip_data <= 32'hXX112233;

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b0000;
        rx_ip_data <= 32'h44556677;

        repeat(2) @(posedge rx_clk);
        #1;
        #1;

        check_outputs(32'h11223344, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: SOF at Byte 1 (Offset 2)", test_num);

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b0010;
        rx_ip_data <= 32'hXXXX1122;

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b0000;
        rx_ip_data <= 32'h33445566;

        repeat(2) @(posedge rx_clk);
        #1;
        #1;

        check_outputs(32'h11223344, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: SOF at Byte 0 (Offset 3)", test_num);

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b0001;
        rx_ip_data <= 32'hXXXXXX11;

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b0000;
        rx_ip_data <= 32'h22334455;

        repeat(2) @(posedge rx_clk);
        #1;
        #1;

        check_outputs(32'h11223344, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: No SOF Signal", test_num);

        @(posedge rx_clk);
        rx_ip_sof  <= 4'b0000;
        rx_ip_data <= 32'hAAAAAAAA;

        repeat(3) @(posedge rx_clk);
        #1;


        if (rx_sof === 1'b0) begin
            $display("PASS");
            $display("  Outputs: rx_sof=%b", rx_sof);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL");
            $display("  Expected: rx_sof=0");
            $display("  Got:      rx_sof=%b", rx_sof);
            fail_count = fail_count + 1;
        end
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
        input [31:0] expected_rx_data;
        input expected_rx_sof;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_rx_sof === (expected_rx_sof ^ rx_sof ^ expected_rx_sof)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h, rx_sof=%b",
                         rx_data, rx_sof);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h, rx_sof=%b",
                         expected_rx_data, expected_rx_sof);
                $display("  Got:      rx_data=%h, rx_sof=%b",
                         rx_data, rx_sof);
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
        $dumpvars(0,rx_clk, rx_ip_data, rx_ip_sof, rx_data, rx_sof);
    end

endmodule
