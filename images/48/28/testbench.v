`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_i;
    reg clk;
    reg [31:0] data_i;
    reg rst;
    reg rx_ack_i;
    reg [23:0] rx_data_i;
    reg we_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk(clk),
        .data_i(data_i),
        .rst(rst),
        .rx_ack_i(rx_ack_i),
        .rx_data_i(rx_data_i),
        .we_i(we_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rx_ack_i = 0;
            rx_data_i = 0;
            data_i = 0;
            addr_i = 0;
            we_i = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            reset_dut();
            addr_i = 32'h0;
            #1;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single data push");
            reset_dut();
            rx_data_i = 24'hABCDEF;
            rx_ack_i = 1;
            @(posedge clk);
            rx_ack_i = 0;
            @(posedge clk);
            addr_i = 32'h0;
            #1;
            #1;

            check_outputs(32'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple data pushes");
            reset_dut();
            repeat(5) begin
                rx_data_i = $random & 24'hFFFFFF;
                rx_ack_i = 1;
                @(posedge clk);
                rx_ack_i = 0;
                @(posedge clk);
            end
            addr_i = 32'h0;
            #1;
            #1;

            check_outputs(32'h5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write enable pop logic");
            reset_dut();

            repeat(2) begin
                rx_data_i = $random;
                rx_ack_i = 1;
                @(posedge clk);
            end
            rx_ack_i = 0;
            @(posedge clk);

            we_i = 1;
            addr_i = 32'h0;
            @(posedge clk);
            we_i = 0;
            @(posedge clk);

            addr_i = 32'h0;
            #1;
            #1;

            check_outputs(32'h1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data retrieval from buffer");
            reset_dut();
            rx_data_i = 24'h123456;
            rx_ack_i = 1;
            @(posedge clk);
            rx_ack_i = 0;
            @(posedge clk);

            addr_i = 32'h1;
            #1;

            #1;


            check_outputs(32'h123456);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Buffer capacity limit");
            reset_dut();
            repeat(70) begin
                rx_data_i = $random;
                rx_ack_i = 1;
                @(posedge clk);
            end
            rx_ack_i = 0;
            @(posedge clk);
            addr_i = 32'h0;
            #1;

            #1;


            check_outputs(32'd64);
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
        input [31:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,addr_i, clk, data_i, rst, rx_ack_i, rx_data_i, we_i, data_o);
    end

endmodule
