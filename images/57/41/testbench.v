`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Upper bits are 0000 (data_in = 16'h0FFF)");
            reset_dut();
            data_in = 16'h0FFF;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Upper bits are 1111 (data_in = 16'hF001)");
            reset_dut();
            data_in = 16'hF001;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Addition 0x1 + 0x2");
            reset_dut();
            data_in = 16'h1002;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Addition 0xA + 0x5");
            reset_dut();
            data_in = 16'hA005;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Overflow 0xE + 0x3 = 0x11 -> 0x1");
            reset_dut();
            data_in = 16'hE003;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Upper bits plus zero (0x7 + 0x0)");
            reset_dut();
            data_in = 16'h7000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Max overflow 0xE + 0xF = 0x1D -> 0xD");
            reset_dut();
            data_in = 16'hE00F;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hD);
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
