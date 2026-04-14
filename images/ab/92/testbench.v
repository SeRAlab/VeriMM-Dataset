`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .parity(parity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 16'd0;
            repeat(4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 16'b0000_0001_1111_1111;
            @(posedge clk);
            #2;
            $display("Testcase 001: Popcount 9");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 16'b0000_0111_1111_1111;
            @(posedge clk);
            #2;
            $display("Testcase 002: Popcount 11");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 16'b0001_1111_1111_1111;
            @(posedge clk);
            #2;
            $display("Testcase 003: Popcount 13");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 16'b0111_1111_1111_1111;
            @(posedge clk);
            #2;
            $display("Testcase 004: Popcount 15");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 16'h0001;
            @(posedge clk);
            #2;
            $display("Testcase 005: Popcount 1");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 16'h007F;
            @(posedge clk);
            #2;
            $display("Testcase 006: Popcount 7");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 16'h00FF;
            @(posedge clk);
            #2;
            $display("Testcase 007: Popcount 8");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data = 16'h03FF;
            @(posedge clk);
            #2;
            $display("Testcase 008: Popcount 10");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            data = 16'hFFFF;
            @(posedge clk);
            #2;
            $display("Testcase 009: Popcount 16");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            data = 16'h0000;
            @(posedge clk);
            #2;
            $display("Testcase 010: Popcount 0");
            #1;

            check_outputs(1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_parity;
        begin
            if (expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: parity=%b",
                         parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b",
                         expected_parity);
                $display("  Got:      parity=%b",
                         parity);
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
        $dumpvars(0,clk, data, parity);
    end

endmodule
