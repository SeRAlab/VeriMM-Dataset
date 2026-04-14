`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .product(product)
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
            a = 0;
            b = 0;
            @(posedge clk);
            reset = 0;

            @(posedge clk);
            endtask
    task testcase001;

        begin
            $display("Testcase 001: Zero multiplication (0 * 0)");
            reset_dut();
            a = 8'd0;
            b = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Multiplication by zero (255 * 0)");
            reset_dut();
            a = 8'd255;
            b = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiplication by one (1 * 127)");
            reset_dut();
            a = 8'd1;
            b = 8'd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd127);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simple multiplication (12 * 11)");
            reset_dut();
            a = 8'd12;
            b = 8'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd132);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Maximum values (255 * 255)");
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Powers of two (16 * 16)");
            reset_dut();
            a = 8'd16;
            b = 8'd16;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Prime numbers (13 * 17)");
            reset_dut();
            a = 8'd13;
            b = 8'd17;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd221);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Verify Synchronous Reset middle of operation");
            reset_dut();
            a = 8'd50;
            b = 8'd2;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
            reset = 0;
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Alternating bits (0xAA * 0x55)");
            reset_dut();
            a = 8'hAA;
            b = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3872);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Large value and small value (200 * 3)");
            reset_dut();
            a = 8'd200;
            b = 8'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd600);
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
        input [15:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,a, b, clk, reset, product);
    end

endmodule
