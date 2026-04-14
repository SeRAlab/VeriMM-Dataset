`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_i;
    reg clk;
    reg [31:0] data_i;
    reg rst;
    reg tx_pop_i;
    reg we_i;
    wire [31:0] data_o;
    wire [5:0] queued_ff;
    wire tx_ack_o;

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
        .tx_pop_i(tx_pop_i),
        .we_i(we_i),
        .data_o(data_o),
        .queued_ff(queued_ff),
        .tx_ack_o(tx_ack_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we_i = 0;
            tx_pop_i = 0;
            data_i = 0;
            addr_i = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(32'h0, 6'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Write");
            reset_dut();
            we_i = 1;
            addr_i = 32'd0;
            data_i = 32'hABCDEF01;
            @(posedge clk);
            #1 we_i = 0;
            @(posedge clk);

            #1;


            check_outputs(data_o, 6'd1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Write then Dequeue");
            reset_dut();

            we_i = 1;
            addr_i = 32'd0;
            data_i = 32'h12345678;
            @(posedge clk);
            #1 we_i = 0;
            @(posedge clk);

            tx_pop_i = 1;
            @(posedge clk);
            #1 tx_pop_i = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h12345678, 6'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Multiple Writes, Single Pop");
            reset_dut();

            we_i = 1;
            addr_i = 32'd0; data_i = 32'h1111; @(posedge clk);
            addr_i = 32'd1; data_i = 32'h2222; @(posedge clk);
            addr_i = 32'd2; data_i = 32'h3333; @(posedge clk);
            #1 we_i = 0;
            @(posedge clk);

            tx_pop_i = 1;
            @(posedge clk);
            #1 tx_pop_i = 0;
            @(posedge clk);
            #1;

            check_outputs(32'h1111, 6'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Sequential Pops");
            reset_dut();

            we_i = 1;
            addr_i = 32'd0; data_i = 32'hAAAA; @(posedge clk);
            addr_i = 32'd1; data_i = 32'hBBBB; @(posedge clk);
            #1 we_i = 0;
            @(posedge clk);

            tx_pop_i = 1;
            @(posedge clk);

            tx_pop_i = 1;
            @(posedge clk);
            #1 tx_pop_i = 0;
            @(posedge clk);

            #1;


            check_outputs(32'hBBBB, 6'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Write at Address 63 and Pop");
            reset_dut();

            we_i = 1;
            addr_i = 32'd0; data_i = 32'hFEED; @(posedge clk);
            addr_i = 32'd63; data_i = 32'hFACE; @(posedge clk);
            #1 we_i = 0;
            @(posedge clk);

            #1;


            check_outputs(data_o, 6'd2, 1'b0);
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
        input [5:0] expected_queued_ff;
        input expected_tx_ack_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_queued_ff === (expected_queued_ff ^ queued_ff ^ expected_queued_ff) &&
                expected_tx_ack_o === (expected_tx_ack_o ^ tx_ack_o ^ expected_tx_ack_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, queued_ff=%h, tx_ack_o=%b",
                         data_o, queued_ff, tx_ack_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, queued_ff=%h, tx_ack_o=%b",
                         expected_data_o, expected_queued_ff, expected_tx_ack_o);
                $display("  Got:      data_o=%h, queued_ff=%h, tx_ack_o=%b",
                         data_o, queued_ff, tx_ack_o);
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
        $dumpvars(0,addr_i, clk, data_i, rst, tx_pop_i, we_i, data_o, queued_ff, tx_ack_o);
    end

endmodule
