`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] data;
    reg rst_n;
    wire [15:0] R0;
    wire [15:0] R1;
    wire [15:0] R2;
    wire [15:0] R3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data(data),
        .rst_n(rst_n),
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            control = 0;
            data = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check");
            reset_dut();

            control = 16'h000F;
            data = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write to R0 and single read");
            reset_dut();

            data = 16'hA5A5;
            control = 16'h0000;
            @(posedge clk);
            #1;

            control = 16'h0001;
            #1;
            #1;

            check_outputs(16'hA5A5, 16'hzzzz, 16'hzzzz, 16'hzzzz);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write all registers, read all");
            reset_dut();


            data = 16'h1111; control = 16'h0000; @(posedge clk); #1;

            data = 16'h2222; control = 16'h4000; @(posedge clk); #1;

            data = 16'h3333; control = 16'h8000; @(posedge clk); #1;

            data = 16'h4444; control = 16'hC000; @(posedge clk); #1;


            control = 16'h000F;
            #1;
            #1;

            check_outputs(16'h1111, 16'h2222, 16'h3333, 16'h4444);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: High Impedance (No Read Selected)");
            reset_dut();

            data = 16'hFFFF;
            control = 16'h4000;
            @(posedge clk);
            #1;

            control = 16'h0000;
            #1;
            #1;

            check_outputs(16'hzzzz, 16'hzzzz, 16'hzzzz, 16'hzzzz);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite register R2");
            reset_dut();

            data = 16'hAAAA; control = 16'h8000; @(posedge clk); #1;

            data = 16'h5555; control = 16'h8000; @(posedge clk); #1;


            control = 16'h0004;
            #1;
            #1;

            check_outputs(16'hzzzz, 16'hzzzz, 16'h5555, 16'hzzzz);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Mid-operation reset");
            reset_dut();
            data = 16'hBEEF; control = 16'hC000; @(posedge clk); #1;


            rst_n = 0; #5; rst_n = 1; #1;


            control = 16'h0008;
            #1;
            #1;

            check_outputs(16'hzzzz, 16'hzzzz, 16'hzzzz, 16'h0000);
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
        input [15:0] expected_R0;
        input [15:0] expected_R1;
        input [15:0] expected_R2;
        input [15:0] expected_R3;
        begin
            if (expected_R0 === (expected_R0 ^ R0 ^ expected_R0) &&
                expected_R1 === (expected_R1 ^ R1 ^ expected_R1) &&
                expected_R2 === (expected_R2 ^ R2 ^ expected_R2) &&
                expected_R3 === (expected_R3 ^ R3 ^ expected_R3)) begin
                $display("PASS");
                $display("  Outputs: R0=%h, R1=%h, R2=%h, R3=%h",
                         R0, R1, R2, R3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R0=%h, R1=%h, R2=%h, R3=%h",
                         expected_R0, expected_R1, expected_R2, expected_R3);
                $display("  Got:      R0=%h, R1=%h, R2=%h, R3=%h",
                         R0, R1, R2, R3);
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
        $dumpvars(0,clk, control, data, rst_n, R0, R1, R2, R3);
    end

endmodule
