`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk40;
    reg [6:0] data_offset_delay;
    reg [6:0] delay_modifier;
    reg rst;
    reg [5:0] scan_delay;
    reg strb;
    wire [5:0] adc_clock_delay;
    wire [5:0] adc_data_delay;
    wire [5:0] adc_drdy_delay;
    wire saturated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk40(clk40),
        .data_offset_delay(data_offset_delay),
        .delay_modifier(delay_modifier),
        .rst(rst),
        .scan_delay(scan_delay),
        .strb(strb),
        .adc_clock_delay(adc_clock_delay),
        .adc_data_delay(adc_data_delay),
        .adc_drdy_delay(adc_drdy_delay),
        .saturated(saturated)
    );

    // Clock generation (10ns period)
    initial begin
        clk40 = 0;
        forever #5 clk40 = ~clk40;
    end

        task reset_dut;

        begin
            rst = 1;
            strb = 0;
            data_offset_delay = 0;
            delay_modifier = 0;
            scan_delay = 0;
            @(posedge clk40);
            #2 rst = 0;
            @(posedge clk40);
            repeat(2) @(posedge clk40);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Basic Calculation", test_num);
            scan_delay = 6'd10;
            data_offset_delay = 7'd5;
            delay_modifier = 7'd2;
            strb = 1;
            @(posedge clk40);
            strb = 0;
            repeat(3) @(posedge clk40);
            #1;

            check_outputs(6'd12, 6'd17, 6'd17, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: All Zeros", test_num);
            scan_delay = 6'd0;
            data_offset_delay = 7'd0;
            delay_modifier = 7'd0;
            strb = 1;
            @(posedge clk40);
            strb = 0;
            repeat(3) @(posedge clk40);
            #1;

            check_outputs(6'd0, 6'd0, 6'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Upper Saturation", test_num);
            scan_delay = 6'd40;
            delay_modifier = 7'd10;
            data_offset_delay = 7'd30;
            strb = 1;
            @(posedge clk40);
            strb = 0;
            repeat(3) @(posedge clk40);
            #1;

            check_outputs(6'd50, 6'd63, 6'd63, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Boundary Scan Max", test_num);
            scan_delay = 6'd63;
            data_offset_delay = 7'd0;
            delay_modifier = 7'd0;
            strb = 1;
            @(posedge clk40);
            strb = 0;
            repeat(3) @(posedge clk40);
            #1;

            check_outputs(6'd63, 6'd63, 6'd63, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Strobe Signal Check", test_num);

            scan_delay = 6'd20;
            data_offset_delay = 7'd10;
            delay_modifier = 7'd5;
            repeat(2) @(posedge clk40);

            if (adc_clock_delay == 0) begin
                strb = 1;
                @(posedge clk40);
                strb = 0;
                repeat(3) @(posedge clk40);
                #1;

                check_outputs(6'd25, 6'd35, 6'd35, 1'b0);
            end else begin
                $display("FAIL: Outputs changed before strobe");
                fail_count = fail_count + 1;
            end
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
        input [5:0] expected_adc_clock_delay;
        input [5:0] expected_adc_data_delay;
        input [5:0] expected_adc_drdy_delay;
        input expected_saturated;
        begin
            if (expected_adc_clock_delay === (expected_adc_clock_delay ^ adc_clock_delay ^ expected_adc_clock_delay) &&
                expected_adc_data_delay === (expected_adc_data_delay ^ adc_data_delay ^ expected_adc_data_delay) &&
                expected_adc_drdy_delay === (expected_adc_drdy_delay ^ adc_drdy_delay ^ expected_adc_drdy_delay) &&
                expected_saturated === (expected_saturated ^ saturated ^ expected_saturated)) begin
                $display("PASS");
                $display("  Outputs: adc_clock_delay=%h, adc_data_delay=%h, adc_drdy_delay=%h, saturated=%b",
                         adc_clock_delay, adc_data_delay, adc_drdy_delay, saturated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_clock_delay=%h, adc_data_delay=%h, adc_drdy_delay=%h, saturated=%b",
                         expected_adc_clock_delay, expected_adc_data_delay, expected_adc_drdy_delay, expected_saturated);
                $display("  Got:      adc_clock_delay=%h, adc_data_delay=%h, adc_drdy_delay=%h, saturated=%b",
                         adc_clock_delay, adc_data_delay, adc_drdy_delay, saturated);
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
        $dumpvars(0,clk40, data_offset_delay, delay_modifier, rst, scan_delay, strb, adc_clock_delay, adc_data_delay, adc_drdy_delay, saturated);
    end

endmodule
