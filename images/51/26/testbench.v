`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset_n;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset_n(reset_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset_n <= 0;
            in <= 8'h00;
            @(posedge clk);
            reset_n <= 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State");
            reset_dut();

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single bit falling edge (Bit 0)");
            reset_dut();
            @(posedge clk) in <= 8'h01;
            @(posedge clk) in <= 8'h00;
            @(posedge clk);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple bits falling edge (0xAA -> 0x00)");
            reset_dut();
            @(posedge clk) in <= 8'hAA;
            @(posedge clk) in <= 8'h00;
            @(posedge clk);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Persistence/Sticky check");
            reset_dut();
            @(posedge clk) in <= 8'h80;
            @(posedge clk) in <= 8'h00;
            @(posedge clk) in <= 8'hFF;
            @(posedge clk) in <= 8'hFF;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Cumulative detection over multiple cycles");
            reset_dut();

            @(posedge clk) in <= 8'h01;
            @(posedge clk) in <= 8'h00;

            @(posedge clk) in <= 8'h10;
            @(posedge clk) in <= 8'h00;

            @(posedge clk) in <= 8'h80;
            @(posedge clk) in <= 8'h00;
            @(posedge clk);
            #1;

            check_outputs(8'h91);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Rising edges ignored");
            reset_dut();
            @(posedge clk) in <= 8'h00;
            @(posedge clk) in <= 8'hFF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Complex sequence");
            reset_dut();
            @(posedge clk) in <= 8'hFF;
            @(posedge clk) in <= 8'hF0;
            @(posedge clk) in <= 8'h0F;
            @(posedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Reset clears sticky outputs");
            reset_dut();
            @(posedge clk) in <= 8'hFF;
            @(posedge clk) in <= 8'h00;
            @(posedge clk);

            if (out == 8'hFF) begin

                @(posedge clk) reset_n <= 0;
                @(posedge clk) reset_n <= 1;
                @(posedge clk);
                #1;

                check_outputs(8'h00);
            end else begin
                $display("Capture failed before reset check");
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_out;
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
        $dumpvars(0,clk, in, reset_n, out);
    end

endmodule
