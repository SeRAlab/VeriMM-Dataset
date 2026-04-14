`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] I;
    reg clk;
    wire EN;
    wire [2:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .clk(clk),
        .EN(EN),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            I = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: All zeros");
            reset_dut();
            I = 8'b0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input 8'b0000_0001 (Bit 0)");
            reset_dut();
            I = 8'b0000_0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input 8'b1000_0000 (Bit 7)");
            reset_dut();
            I = 8'b1000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd7);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Multiple bits 8'b1000_0011 (Priority Bit 7)");
            reset_dut();
            I = 8'b1000_0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd7);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input 8'b0001_0000 (Bit 4)");
            reset_dut();
            I = 8'b0001_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd4);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Multiple bits 8'b0000_1111 (Priority Bit 3)");
            reset_dut();
            I = 8'b0000_1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd3);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: All bits 8'b1111_1111 (Priority Bit 7)");
            reset_dut();
            I = 8'b1111_1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd7);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input 8'b0000_0010 (Bit 1)");
            reset_dut();
            I = 8'b0000_0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd1);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input 8'b0100_0000 (Bit 6)");
            reset_dut();
            I = 8'b0100_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd6);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input 8'b0101_0101 (Priority Bit 6)");
            reset_dut();
            I = 8'b0101_0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd6);
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
        input expected_EN;
        input [2:0] expected_OUT;
        begin
            if (expected_EN === (expected_EN ^ EN ^ expected_EN) &&
                expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: EN=%b, OUT=%h",
                         EN, OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%b, OUT=%h",
                         expected_EN, expected_OUT);
                $display("  Got:      EN=%b, OUT=%h",
                         EN, OUT);
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
        $dumpvars(0,I, clk, EN, OUT);
    end

endmodule
