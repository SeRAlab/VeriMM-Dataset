`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    wire [3:0] dout;
    wire strobe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .dout(dout),
        .strobe(strobe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            din = 0;

            repeat(10) @(posedge clk);
            #1;
        end
        endtask
    task send_frame;

        input [9:0] frame;
        integer i;
        begin
            for (i = 9; i >= 0; i = i - 1) begin
                din = frame[i];
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Valid frame (Data 1010, Even Parity 0)");
            send_frame(10'b0101_1010_0_0);
            #1;

            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Valid frame (Data 1110, Even Parity 1)");
            send_frame(10'b0101_1110_1_0);
            #1;

            check_outputs(4'b1110, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Invalid Pattern (Upper nibble 1111)");
            send_frame(10'b1111_1010_0_0);
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Invalid Parity Bit");
            send_frame(10'b0101_1010_1_0);
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Mid-shift check (Strobe should remain low)");

            for (i = 9; i >= 1; i = i - 1) begin
                din = 10'b0101_1100_0_0[i];
                @(posedge clk);
                #1;
                if (strobe === 1'b1) begin
                    $display("FAIL: Strobe asserted prematurely at bit %0d", i);
                end
            end

            din = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1100, 1'b1);
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
        input [3:0] expected_dout;
        input expected_strobe;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_strobe === (expected_strobe ^ strobe ^ expected_strobe)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, strobe=%b",
                         dout, strobe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, strobe=%b",
                         expected_dout, expected_strobe);
                $display("  Got:      dout=%h, strobe=%b",
                         dout, strobe);
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
        $dumpvars(0,clk, din, dout, strobe);
    end

endmodule
