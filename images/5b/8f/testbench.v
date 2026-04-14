`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_data;
    reg wr;
    wire [31:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .wr(wr),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            wr <= 1;
            in_data <= 32'h00000000;
            @(posedge clk);
            wr <= 0;
            in_data <= 32'h00000000;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write (1.0)");
            reset_dut();
            @(posedge clk);
            wr <= 1;
            in_data <= 32'h3F800000;
            @(posedge clk);
            wr <= 0;
            #2;
            #1;

            check_outputs(32'h3F800000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write Disable Check");
            reset_dut();
            @(posedge clk);
            wr <= 0;
            in_data <= 32'h40000000;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sequential Writes");
            reset_dut();
            @(posedge clk);
            wr <= 1;
            in_data <= 32'h40400000;
            @(posedge clk);
            in_data <= 32'h40800000;
            @(posedge clk);
            wr <= 0;
            #2;
            #1;

            check_outputs(32'h40800000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Data Retention");
            reset_dut();
            @(posedge clk);
            wr <= 1;
            in_data <= 32'h7F800000;
            @(posedge clk);
            wr <= 0;
            in_data <= 32'h00000000;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(32'h7F800000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All Bits Toggled");
            reset_dut();
            @(posedge clk);
            wr <= 1;
            in_data <= 32'hFFFFFFFF;
            @(posedge clk);
            wr <= 0;
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, wr, out_data);
    end

endmodule
