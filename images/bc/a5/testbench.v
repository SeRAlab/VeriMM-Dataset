`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg [7:0] in;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .in(in),
        .out(out)
    );

        task reset_dut;

        begin
            @(posedge clock);
            enable = 1;
            in = 8'h00;
            repeat(16) begin
                @(posedge clock);
            end
            enable = 0;
            #1;
            $display("Status: Reset sequence (16 zeros) completed.");
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Single byte shift in");
            reset_dut();
            @(posedge clock);
            #1;
            enable = 1;
            in = 8'hA5;
            @(posedge clock);
            #1;
            enable = 0;
            #1;

            check_outputs(128'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Multiple bytes accumulation (4 bytes)");
            reset_dut();
            @(posedge clock);
            #1;
            enable = 1;
            in = 8'h01; @(posedge clock); #1;
            in = 8'h02; @(posedge clock); #1;
            in = 8'h03; @(posedge clock); #1;
            in = 8'h04; @(posedge clock); #1;
            enable = 0;
            #1;

            check_outputs(128'h01020304);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Check if enable=0 prevents shifting");
            reset_dut();
            @(posedge clock);
            #1;
            enable = 1;
            in = 8'hDE; @(posedge clock); #1;
            enable = 0;
            in = 8'hFF; @(posedge clock); #1;
            in = 8'hFF; @(posedge clock); #1;
            enable = 1;
            in = 8'hAD; @(posedge clock); #1;
            enable = 0;
            #1;

            check_outputs(128'hDEAD);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nTestcase 004: Fill the entire 128-bit register (16 bytes)");
            reset_dut();
            @(posedge clock);
            #1;
            enable = 1;
            for (i = 1; i <= 16; i = i + 1) begin
                in = i[7:0];
                @(posedge clock);
                #1;
            end
            enable = 0;
            #1;

            check_outputs(128'h0102030405060708090A0B0C0D0E0F10);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Overflow check (17th byte should push out 1st byte)");
            reset_dut();
            @(posedge clock);
            #1;
            enable = 1;

            in = 8'hFF; @(posedge clock); #1;
            repeat(16) begin
                in = 8'hAA; @(posedge clock); #1;
            end
            enable = 0;

            #1;


            check_outputs({16{8'hAA}});
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
        input [127:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clock, enable, in, out);
    end

endmodule
