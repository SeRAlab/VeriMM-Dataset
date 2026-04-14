`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] TxGain_rampGainStep;
    reg [3:0] TxGain_rampTimeStep;
    reg [5:0] TxGain_target;
    reg Tx_swEnable;
    reg clk;
    reg [7:0] dly_PowerAmpEn;
    reg [7:0] dly_RampGain;
    reg [7:0] dly_TxStart;
    reg [7:0] dly_hwTxEn;
    reg reset;
    wire hw_PAEn;
    wire hw_TxEn;
    wire [5:0] hw_TxGain;
    wire hw_TxStart;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .TxGain_rampGainStep(TxGain_rampGainStep),
        .TxGain_rampTimeStep(TxGain_rampTimeStep),
        .TxGain_target(TxGain_target),
        .Tx_swEnable(Tx_swEnable),
        .clk(clk),
        .dly_PowerAmpEn(dly_PowerAmpEn),
        .dly_RampGain(dly_RampGain),
        .dly_TxStart(dly_TxStart),
        .dly_hwTxEn(dly_hwTxEn),
        .reset(reset),
        .hw_PAEn(hw_PAEn),
        .hw_TxEn(hw_TxEn),
        .hw_TxGain(hw_TxGain),
        .hw_TxStart(hw_TxStart)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Tx_swEnable = 0;
            TxGain_target = 0;
            TxGain_rampGainStep = 0;
            TxGain_rampTimeStep = 0;
            dly_hwTxEn = 0;
            dly_TxStart = 0;
            dly_PowerAmpEn = 0;
            dly_RampGain = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic sequence with sequential delays", test_num);
            reset_dut();


            dly_hwTxEn     = 8'd10;
            dly_PowerAmpEn = 8'd20;
            dly_TxStart    = 8'd30;
            dly_RampGain   = 8'd40;

            TxGain_target       = 6'd50;
            TxGain_rampGainStep = 4'd5;
            TxGain_rampTimeStep = 4'd2;

            Tx_swEnable = 1;



            repeat (100) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 6'd50, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Minimum delays and fast ramping", test_num);
            reset_dut();

            dly_hwTxEn     = 8'd1;
            dly_PowerAmpEn = 8'd1;
            dly_TxStart    = 8'd1;
            dly_RampGain   = 8'd1;

            TxGain_target       = 6'd63;
            TxGain_rampGainStep = 4'd15;
            TxGain_rampTimeStep = 4'd1;

            Tx_swEnable = 1;


            repeat (20) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b1, 6'd63, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Out-of-order delay sequence", test_num);
            reset_dut();

            dly_hwTxEn     = 8'd40;
            dly_PowerAmpEn = 8'd10;
            dly_TxStart    = 8'd20;
            dly_RampGain   = 8'd5;

            TxGain_target       = 6'd20;
            TxGain_rampGainStep = 4'd2;
            TxGain_rampTimeStep = 4'd1;

            Tx_swEnable = 1;

            repeat (60) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 6'd20, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Slow ramping time steps", test_num);
            reset_dut();

            dly_hwTxEn     = 8'd5;
            dly_PowerAmpEn = 8'd5;
            dly_TxStart    = 8'd5;
            dly_RampGain   = 8'd5;

            TxGain_target       = 6'd10;
            TxGain_rampGainStep = 4'd1;
            TxGain_rampTimeStep = 4'd10;

            Tx_swEnable = 1;


            repeat (150) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 6'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: System reset mid-sequence", test_num);
            reset_dut();

            dly_hwTxEn     = 8'd50;
            dly_PowerAmpEn = 8'd50;
            dly_TxStart    = 8'd50;
            dly_RampGain   = 8'd50;
            TxGain_target  = 6'd32;
            Tx_swEnable    = 1;

            repeat (25) @(posedge clk);

            reset = 1;
            repeat (5) @(posedge clk);
            reset = 0;



            repeat (50) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 6'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Maximum delays and target gain", test_num);
            reset_dut();

            dly_hwTxEn     = 8'hFF;
            dly_PowerAmpEn = 8'hFF;
            dly_TxStart    = 8'hFF;
            dly_RampGain   = 8'hFF;

            TxGain_target       = 6'd63;
            TxGain_rampGainStep = 4'd1;
            TxGain_rampTimeStep = 4'd1;

            Tx_swEnable = 1;


            repeat (350) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 6'd63, 1'b1);
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
        input expected_hw_PAEn;
        input expected_hw_TxEn;
        input [5:0] expected_hw_TxGain;
        input expected_hw_TxStart;
        begin
            if (expected_hw_PAEn === (expected_hw_PAEn ^ hw_PAEn ^ expected_hw_PAEn) &&
                expected_hw_TxEn === (expected_hw_TxEn ^ hw_TxEn ^ expected_hw_TxEn) &&
                expected_hw_TxGain === (expected_hw_TxGain ^ hw_TxGain ^ expected_hw_TxGain) &&
                expected_hw_TxStart === (expected_hw_TxStart ^ hw_TxStart ^ expected_hw_TxStart)) begin
                $display("PASS");
                $display("  Outputs: hw_PAEn=%b, hw_TxEn=%b, hw_TxGain=%h, hw_TxStart=%b",
                         hw_PAEn, hw_TxEn, hw_TxGain, hw_TxStart);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hw_PAEn=%b, hw_TxEn=%b, hw_TxGain=%h, hw_TxStart=%b",
                         expected_hw_PAEn, expected_hw_TxEn, expected_hw_TxGain, expected_hw_TxStart);
                $display("  Got:      hw_PAEn=%b, hw_TxEn=%b, hw_TxGain=%h, hw_TxStart=%b",
                         hw_PAEn, hw_TxEn, hw_TxGain, hw_TxStart);
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
        $dumpvars(0,TxGain_rampGainStep, TxGain_rampTimeStep, TxGain_target, Tx_swEnable, clk, dly_PowerAmpEn, dly_RampGain, dly_TxStart, dly_hwTxEn, reset, hw_PAEn, hw_TxEn, hw_TxGain, hw_TxStart);
    end

endmodule
