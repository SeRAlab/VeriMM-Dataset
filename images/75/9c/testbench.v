`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rst;
    reg tdmfrm;
    reg tdmrx;
    wire [7:0] dout;
    wire tdmtx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .tdmfrm(tdmfrm),
        .tdmrx(tdmrx),
        .dout(dout),
        .tdmtx(tdmtx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tdmfrm = 0;
            tdmrx = 0;
            din = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task perform_tdm_transfer;

        input [7:0] data_to_send;
        input [7:0] serial_in;
        integer i;
        begin
            din = data_to_send;
            @(posedge clk);
            #1 tdmfrm = 1;
            for (i = 7; i >= 0; i = i - 1) begin
                tdmrx = serial_in[i];
                @(posedge clk);
                #1 tdmfrm = 0;
            end
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Standard Transfer 0xA5 TX, 0x3C RX", test_num);


            perform_tdm_transfer(8'hA5, 8'h3C);

            #1;


            check_outputs(8'h3C, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Transfer", test_num);
            perform_tdm_transfer(8'h00, 8'h00);
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Transfer", test_num);
            perform_tdm_transfer(8'hFF, 8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits 0x55 TX, 0xAA RX", test_num);


            perform_tdm_transfer(8'h55, 8'hAA);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits 0xAA TX, 0x55 RX", test_num);


            perform_tdm_transfer(8'hAA, 8'h55);
            #1;

            check_outputs(8'h55, 1'b0);
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
        input [7:0] expected_dout;
        input expected_tdmtx;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_tdmtx === (expected_tdmtx ^ tdmtx ^ expected_tdmtx)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, tdmtx=%b",
                         dout, tdmtx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, tdmtx=%b",
                         expected_dout, expected_tdmtx);
                $display("  Got:      dout=%h, tdmtx=%b",
                         dout, tdmtx);
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
        $dumpvars(0,clk, din, rst, tdmfrm, tdmrx, dout, tdmtx);
    end

endmodule
