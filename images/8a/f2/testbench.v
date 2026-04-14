`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [3:0] in;
    reg rst;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .in(in),
        .rst(rst),
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
            rst = 1;
            en = 0;
            in = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Reset");
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Shift In (1)");
            reset_dut();
            @(posedge clk);
            en <= 1;
            in <= 4'b0001;
            @(posedge clk);
            en <= 0;
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sequential Shift (1011)");
            reset_dut();
            en <= 1;

            in <= 4'b0001; @(posedge clk);

            in <= 4'b0000; @(posedge clk);

            in <= 4'b0001; @(posedge clk);

            in <= 4'b1111; @(posedge clk);

            en <= 0;
            #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable Signal Check");
            reset_dut();
            en <= 1;
            in <= 4'b0001; @(posedge clk);

            en <= 0;
            in <= 4'b0001; @(posedge clk);
            in <= 4'b1111; @(posedge clk);

            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overflow Check (Shift 5 bits)");
            reset_dut();
            en <= 1;
            in <= 4'b0001; @(posedge clk);
            in <= 4'b0000; @(posedge clk);
            in <= 4'b0000; @(posedge clk);
            in <= 4'b0000; @(posedge clk);
            in <= 4'b0001; @(posedge clk);

            en <= 0;
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating Bits (1010)");
            reset_dut();
            en <= 1;
            in <= 1; @(posedge clk);
            in <= 0; @(posedge clk);
            in <= 1; @(posedge clk);
            in <= 0; @(posedge clk);

            en <= 0;
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset Priority Check");
            reset_dut();
            en <= 1;
            in <= 1; @(posedge clk);
            in <= 1; @(posedge clk);

            rst <= 1;
            @(posedge clk);
            #1;
            rst <= 0;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, en, in, rst, out);
    end

endmodule
