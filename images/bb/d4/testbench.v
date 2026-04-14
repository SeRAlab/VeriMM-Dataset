`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] input_bus_1;
    reg [31:0] input_bus_2;
    reg reset;
    wire [31:0] output_bus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_bus_1(input_bus_1),
        .input_bus_2(input_bus_2),
        .reset(reset),
        .output_bus(output_bus)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            input_bus_1 = 0;
            input_bus_2 = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All Zeros (0 | 0)");
            reset_dut();
            input_bus_1 = 32'h00000000;
            input_bus_2 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All Ones (0xFFFFFFFF | 0xFFFFFFFF)");
            reset_dut();
            input_bus_1 = 32'hFFFFFFFF;
            input_bus_2 = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Complementary bits (0xAAAAAAAA | 0x55555555)");
            reset_dut();
            input_bus_1 = 32'hAAAAAAAA;
            input_bus_2 = 32'h55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Identity (0x12345678 | 0x00000000)");
            reset_dut();
            input_bus_1 = 32'h12345678;
            input_bus_2 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Alternating Nibbles (0xF0F0F0F0 | 0x0F0F0F0F)");
            reset_dut();
            input_bus_1 = 32'hF0F0F0F0;
            input_bus_2 = 32'h0F0F0F0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Sparse Bits (0x80000001 | 0x00010008)");
            reset_dut();
            input_bus_1 = 32'h80000001;
            input_bus_2 = 32'h00010008;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h80010009);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Random Hex (0xABCD1234 | 0x4321DCBA)");
            reset_dut();
            input_bus_1 = 32'hABCD1234;
            input_bus_2 = 32'h4321DCBA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hEBFDDEBE);
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
        input [31:0] expected_output_bus;
        begin
            if (expected_output_bus === (expected_output_bus ^ output_bus ^ expected_output_bus)) begin
                $display("PASS");
                $display("  Outputs: output_bus=%h",
                         output_bus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_bus=%h",
                         expected_output_bus);
                $display("  Got:      output_bus=%h",
                         output_bus);
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
        $dumpvars(0,clk, input_bus_1, input_bus_2, reset, output_bus);
    end

endmodule
