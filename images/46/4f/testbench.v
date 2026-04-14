`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg RST;
    reg WR;
    wire TX;
    wire TXE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .RST(RST),
        .WR(WR),
        .TX(TX),
        .TXE(TXE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            WR = 0;
            D = 8'h00;
            #20;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Checking Reset State");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge CLK);
            D = 8'h55;
            WR = 1;
            @(posedge CLK);
            WR = 0;

            $display("Testcase 002: Transmitting 0x55 (Alternating bits)");



            repeat(20) @(posedge CLK);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge CLK);
            D = 8'h00;
            WR = 1;
            @(posedge CLK);
            WR = 0;

            $display("Testcase 003: Transmitting 0x00 (All zeros)");
            repeat(20) @(posedge CLK);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge CLK);
            D = 8'hFF;
            WR = 1;
            @(posedge CLK);
            WR = 0;

            $display("Testcase 004: Transmitting 0xFF (All ones)");
            repeat(20) @(posedge CLK);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge CLK);
            D = 8'hA5;
            WR = 1;
            #2;
            if (TXE === 1'b0) begin
                $display("Testcase 005: TXE correctly went low during transmission initiation.");
            end
            @(posedge CLK);
            WR = 0;
            repeat(20) @(posedge CLK);

            $display("Testcase 005: Final state check after 0xA5");
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_TX;
        input expected_TXE;
        begin
            if (expected_TX === (expected_TX ^ TX ^ expected_TX) &&
                expected_TXE === (expected_TXE ^ TXE ^ expected_TXE)) begin
                $display("PASS");
                $display("  Outputs: TX=%b, TXE=%b",
                         TX, TXE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TX=%b, TXE=%b",
                         expected_TX, expected_TXE);
                $display("  Got:      TX=%b, TXE=%b",
                         TX, TXE);
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
        $dumpvars(0,CLK, D, RST, WR, TX, TXE);
    end

endmodule
