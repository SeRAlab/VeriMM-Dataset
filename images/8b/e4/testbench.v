`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] adc_databus;
    reg clock;
    reg nReset;
    reg testModeFlag;
    wire [9:0] dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_databus(adc_databus),
        .clock(clock),
        .nReset(nReset),
        .testModeFlag(testModeFlag),
        .dataOut(dataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            nReset = 0;
            adc_databus = 10'h000;
            testModeFlag = 0;
            @(posedge clock);
            #2;
            nReset = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            testModeFlag = 0;
            adc_databus = 10'h123;
            @(posedge clock);
            #1;
            adc_databus = 10'h3AC;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'h3AC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            testModeFlag = 1;
            adc_databus = 10'h000;





            repeat(3) @(posedge clock);
            #1;
            #1;

            check_outputs(10'h003);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            testModeFlag = 1;
            repeat(5) @(posedge clock);


            @(negedge clock);
            testModeFlag = 0;
            adc_databus = 10'h2BB;

            @(posedge clock);
            #1;
            #1;

            check_outputs(10'h2BB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            testModeFlag = 0;
            adc_databus = 10'h3FF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(10'h3FF);
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
        input [9:0] expected_dataOut;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h",
                         dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h",
                         expected_dataOut);
                $display("  Got:      dataOut=%h",
                         dataOut);
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
        $dumpvars(0,adc_databus, clock, nReset, testModeFlag, dataOut);
    end

endmodule
