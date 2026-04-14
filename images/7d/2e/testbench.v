`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ACQ_EN;
    reg ACQ_WND;
    reg ADC_CLK;
    reg RESET;
    wire TX_SD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACQ_EN(ACQ_EN),
        .ACQ_WND(ACQ_WND),
        .ADC_CLK(ADC_CLK),
        .RESET(RESET),
        .TX_SD(TX_SD)
    );

    // Clock generation (10ns period)
    initial begin
        ADC_CLK = 0;
        forever #5 ADC_CLK = ~ADC_CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            ACQ_EN = 0;
            ACQ_WND = 0;
            @(posedge ADC_CLK);
            #2 RESET = 0;
            @(posedge ADC_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify S0 state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: S0 -> S1 (ACQ_WND=1)", test_num);
            reset_dut();
            ACQ_WND = 1;
            @(posedge ADC_CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: S1 -> S2 (ACQ_EN=1)", test_num);
            reset_dut();
            ACQ_WND = 1;
            @(posedge ADC_CLK);
            #1 ACQ_EN = 1;
            @(posedge ADC_CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: S2 -> S3 (ACQ_EN=0)", test_num);
            reset_dut();
            ACQ_WND = 1;
            @(posedge ADC_CLK);
            #1 ACQ_EN = 1;
            @(posedge ADC_CLK);
            #1 ACQ_EN = 0;
            @(posedge ADC_CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: S3 -> S0 (ACQ_WND=0)", test_num);
            reset_dut();
            ACQ_WND = 1;
            @(posedge ADC_CLK);
            #1 ACQ_EN = 1;
            @(posedge ADC_CLK);
            #1 ACQ_EN = 0;
            @(posedge ADC_CLK);
            #1 ACQ_WND = 0;
            @(posedge ADC_CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-state Reset (S1 -> RESET)", test_num);
            reset_dut();
            ACQ_WND = 1;
            @(posedge ADC_CLK);
            #1 RESET = 1;
            @(posedge ADC_CLK);
            #2;
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
        input expected_TX_SD;
        begin
            if (expected_TX_SD === (expected_TX_SD ^ TX_SD ^ expected_TX_SD)) begin
                $display("PASS");
                $display("  Outputs: TX_SD=%b",
                         TX_SD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TX_SD=%b",
                         expected_TX_SD);
                $display("  Got:      TX_SD=%b",
                         TX_SD);
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
        $dumpvars(0,ACQ_EN, ACQ_WND, ADC_CLK, RESET, TX_SD);
    end

endmodule
