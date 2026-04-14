`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ADC_0;
    reg ADC_1;
    reg ADC_2;
    reg ADC_3;
    reg ADC_4;
    reg ADC_5;
    reg ADC_6;
    reg ADC_7;
    reg clk;
    reg rst;
    wire [7:0] Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADC_0(ADC_0),
        .ADC_1(ADC_1),
        .ADC_2(ADC_2),
        .ADC_3(ADC_3),
        .ADC_4(ADC_4),
        .ADC_5(ADC_5),
        .ADC_6(ADC_6),
        .ADC_7(ADC_7),
        .clk(clk),
        .rst(rst),
        .Data(Data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            set_adc_inputs(8'h00);
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task set_adc_inputs;

        input [7:0] value;
        begin
            ADC_0 = value[0];
            ADC_1 = value[1];
            ADC_2 = value[2];
            ADC_3 = value[3];
            ADC_4 = value[4];
            ADC_5 = value[5];
            ADC_6 = value[6];
            ADC_7 = value[7];
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Reset Verification...");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: All Zeros Input...");
            reset_dut();
            set_adc_inputs(8'h00);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: All Ones Input...");
            reset_dut();
            set_adc_inputs(8'hFF);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Alternating Pattern 0x55...");
            reset_dut();
            set_adc_inputs(8'h55);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Nibble Inversion...");
            reset_dut();
            set_adc_inputs(8'hF0);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h0F);
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
        input [7:0] expected_Data;
        begin
            if (expected_Data === (expected_Data ^ Data ^ expected_Data)) begin
                $display("PASS");
                $display("  Outputs: Data=%h",
                         Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data=%h",
                         expected_Data);
                $display("  Got:      Data=%h",
                         Data);
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
        $dumpvars(0,ADC_0, ADC_1, ADC_2, ADC_3, ADC_4, ADC_5, ADC_6, ADC_7, clk, rst, Data);
    end

endmodule
