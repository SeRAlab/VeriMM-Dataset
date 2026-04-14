`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a0;
    reg clk;
    reg cs_b;
    reg [15:0] din;
    reg reset_b;
    reg rnw;
    reg rxd;
    wire [15:0] dout;
    wire txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .clk(clk),
        .cs_b(cs_b),
        .din(din),
        .reset_b(reset_b),
        .rnw(rnw),
        .rxd(rxd),
        .dout(dout),
        .txd(txd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_b = 0;
            a0 = 0;
            rnw = 1;
            cs_b = 1;
            din = 16'h0;
            rxd = 1;
            #20;
            reset_b = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State/Reset Check", test_num);


            rnw = 1; a0 = 0; cs_b = 0;
            #20;

            #1;


            check_outputs(16'h0000, 1'b1);
            cs_b = 1;
        end
        endtask

    task testcase002;

        integer i;
        reg [15:0] rx_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 16-bit Reception (RX) - 0xABCD", test_num);
            rx_val = 16'hABCD;


            rxd = 0;
            #BIT_TIME;


            for (i = 0; i < 16; i = i + 1) begin
                rxd = rx_val[i];
                #BIT_TIME;
            end


            rxd = 1;
            #BIT_TIME;


            #100;


            rnw = 1; a0 = 0; cs_b = 0;
            #20;
            #1;

            check_outputs(16'hABCD, 1'b1);
            cs_b = 1;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 16-bit Transmission (TX) Initiation - 0x1234", test_num);


            din = 16'h1234; rnw = 0; a0 = 0; cs_b = 0;
            #10;
            cs_b = 1;


            #(18 * BIT_TIME);
            #100;



            rnw = 1; a0 = 0; cs_b = 0;
            #20;
            #1;

            check_outputs(dout, 1'b1);
            cs_b = 1;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Status Register Access (a0=1)", test_num);


            rnw = 1; a0 = 1; cs_b = 0;
            #20;


            #1;



            check_outputs(dout, 1'b1);
            cs_b = 1;
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
        input [15:0] expected_dout;
        input expected_txd;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_txd === (expected_txd ^ txd ^ expected_txd)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, txd=%b",
                         dout, txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, txd=%b",
                         expected_dout, expected_txd);
                $display("  Got:      dout=%h, txd=%b",
                         dout, txd);
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
        $dumpvars(0,a0, clk, cs_b, din, reset_b, rnw, rxd, dout, txd);
    end

endmodule
