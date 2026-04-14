`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    wire [7:0] BIT;
    wire DONE;
    wire [7:0] NS;
    wire [7:0] PIXEL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .BIT(BIT),
        .DONE(DONE),
        .NS(NS),
        .PIXEL(PIXEL)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking initial state after reset...");
            reset_dut();

            #1;


            check_outputs(8'd0, 1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking BIT increment after 1 cycle...");
            reset_dut();
            @(posedge CLK); #1;
            #1;

            check_outputs(8'd1, 1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking BIT at maximum (5)...");
            reset_dut();
            repeat(5) @(posedge CLK); #1;
            #1;

            check_outputs(8'd5, 1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking PIXEL increment (BIT 5->0 rollover)...");
            reset_dut();
            repeat(6) @(posedge CLK); #1;
            #1;

            check_outputs(8'd0, 1'b0, 8'd0, 8'd1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking state after 2 full pixels (12 cycles)...");
            reset_dut();
            repeat(12) @(posedge CLK); #1;
            #1;

            check_outputs(8'd0, 1'b0, 8'd0, 8'd2);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking terminal state (DONE signal)...");
            reset_dut();
            repeat(1535) @(posedge CLK); #1;
            #1;

            check_outputs(8'd5, 1'b1, 8'd0, 8'd255);
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
        input [7:0] expected_BIT;
        input expected_DONE;
        input [7:0] expected_NS;
        input [7:0] expected_PIXEL;
        begin
            if (expected_BIT === (expected_BIT ^ BIT ^ expected_BIT) &&
                expected_DONE === (expected_DONE ^ DONE ^ expected_DONE) &&
                expected_NS === (expected_NS ^ NS ^ expected_NS) &&
                expected_PIXEL === (expected_PIXEL ^ PIXEL ^ expected_PIXEL)) begin
                $display("PASS");
                $display("  Outputs: BIT=%h, DONE=%b, NS=%h, PIXEL=%h",
                         BIT, DONE, NS, PIXEL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BIT=%h, DONE=%b, NS=%h, PIXEL=%h",
                         expected_BIT, expected_DONE, expected_NS, expected_PIXEL);
                $display("  Got:      BIT=%h, DONE=%b, NS=%h, PIXEL=%h",
                         BIT, DONE, NS, PIXEL);
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
        $dumpvars(0,CLK, RST, BIT, DONE, NS, PIXEL);
    end

endmodule
