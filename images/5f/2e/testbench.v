`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DIN;
    reg W_OUT_REG;
    wire [7:0] OUT_REG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DIN(DIN),
        .W_OUT_REG(W_OUT_REG),
        .OUT_REG(OUT_REG)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            W_OUT_REG = 0;
            DIN = 32'h0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write Operation");
            reset_dut();
            W_OUT_REG = 1;
            DIN = 32'h1234_5678;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h78);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write Disable Operation");
            reset_dut();

            W_OUT_REG = 1;
            DIN = 32'hAAAA_BBCC;
            @(posedge CLK);
            #1;

            W_OUT_REG = 0;
            DIN = 32'hFFFF_FFFF;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential Writes");
            reset_dut();
            W_OUT_REG = 1;
            DIN = 32'h0000_0011;
            @(posedge CLK);
            #1;
            DIN = 32'h0000_0022;
            @(posedge CLK);
            #1;
            DIN = 32'h0000_0033;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data Masking");
            reset_dut();
            W_OUT_REG = 1;
            DIN = 32'hFFFF_FF5A;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary Values");
            reset_dut();
            W_OUT_REG = 1;
            DIN = 32'h0000_00FF;
            @(posedge CLK);
            #1;
            DIN = 32'hFFFF_FF00;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Write Enable Toggling");
            reset_dut();
            W_OUT_REG = 1;
            DIN = 32'h1111_1111;
            @(posedge CLK);
            #1;
            W_OUT_REG = 0;
            DIN = 32'h2222_2222;
            @(posedge CLK);
            #1;
            W_OUT_REG = 1;
            DIN = 32'h3333_3333;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h33);
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
        input [7:0] expected_OUT_REG;
        begin
            if (expected_OUT_REG === (expected_OUT_REG ^ OUT_REG ^ expected_OUT_REG)) begin
                $display("PASS");
                $display("  Outputs: OUT_REG=%h",
                         OUT_REG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT_REG=%h",
                         expected_OUT_REG);
                $display("  Got:      OUT_REG=%h",
                         OUT_REG);
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
        $dumpvars(0,CLK, DIN, W_OUT_REG, OUT_REG);
    end

endmodule
