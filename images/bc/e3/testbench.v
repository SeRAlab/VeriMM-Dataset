`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bloodAbnormality;
    reg clock;
    reg fallDetected;
    reg [1:0] nervousAbnormality;
    reg presureAbnormality;
    reg temperatureAbnormality;
    wire [2:0] abnormaliryWarning;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bloodAbnormality(bloodAbnormality),
        .clock(clock),
        .fallDetected(fallDetected),
        .nervousAbnormality(nervousAbnormality),
        .presureAbnormality(presureAbnormality),
        .temperatureAbnormality(temperatureAbnormality),
        .abnormaliryWarning(abnormaliryWarning)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            presureAbnormality = 0;
            bloodAbnormality = 0;
            fallDetected = 0;
            temperatureAbnormality = 0;
            nervousAbnormality = 2'b00;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: All signals normal");
            test_num = test_num + 1;
            reset_dut();
            presureAbnormality = 0;
            bloodAbnormality = 0;
            fallDetected = 0;
            temperatureAbnormality = 0;
            nervousAbnormality = 2'b00;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single abnormality (Pressure)");
            test_num = test_num + 1;
            reset_dut();
            presureAbnormality = 1;
            bloodAbnormality = 0;
            fallDetected = 0;
            temperatureAbnormality = 0;
            nervousAbnormality = 2'b00;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single abnormality (Blood)");
            test_num = test_num + 1;
            reset_dut();
            presureAbnormality = 0;
            bloodAbnormality = 1;
            fallDetected = 0;
            temperatureAbnormality = 0;
            nervousAbnormality = 2'b00;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Two abnormalities (Fall and Temperature)");
            test_num = test_num + 1;
            reset_dut();
            presureAbnormality = 0;
            bloodAbnormality = 0;
            fallDetected = 1;
            temperatureAbnormality = 1;
            nervousAbnormality = 2'b00;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Nervous system flag bit 0");
            test_num = test_num + 1;
            reset_dut();
            presureAbnormality = 0;
            bloodAbnormality = 0;
            fallDetected = 0;
            temperatureAbnormality = 0;
            nervousAbnormality = 2'b01;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Nervous system both flags");
            test_num = test_num + 1;
            reset_dut();
            presureAbnormality = 0;
            bloodAbnormality = 0;
            fallDetected = 0;
            temperatureAbnormality = 0;
            nervousAbnormality = 2'b11;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Mix of 3 distinct abnormalities");
            test_num = test_num + 1;
            reset_dut();
            presureAbnormality = 1;
            bloodAbnormality = 0;
            fallDetected = 0;
            temperatureAbnormality = 0;
            nervousAbnormality = 2'b11;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: All abnormality signals high (Maximum)");
            test_num = test_num + 1;
            reset_dut();
            presureAbnormality = 1;
            bloodAbnormality = 1;
            fallDetected = 1;
            temperatureAbnormality = 1;
            nervousAbnormality = 2'b11;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Transition check");
            test_num = test_num + 1;
            reset_dut();

            presureAbnormality = 1;
            bloodAbnormality = 1;
            @(posedge clock);
            #2;

            presureAbnormality = 0;
            bloodAbnormality = 0;
            fallDetected = 1;
            temperatureAbnormality = 1;
            nervousAbnormality = 2'b01;
            @(posedge clock);
            #2;
            #1;

            check_outputs(3'd3);
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
        input [2:0] expected_abnormaliryWarning;
        begin
            if (expected_abnormaliryWarning === (expected_abnormaliryWarning ^ abnormaliryWarning ^ expected_abnormaliryWarning)) begin
                $display("PASS");
                $display("  Outputs: abnormaliryWarning=%h",
                         abnormaliryWarning);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abnormaliryWarning=%h",
                         expected_abnormaliryWarning);
                $display("  Got:      abnormaliryWarning=%h",
                         abnormaliryWarning);
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
        $dumpvars(0,bloodAbnormality, clock, fallDetected, nervousAbnormality, presureAbnormality, temperatureAbnormality, abnormaliryWarning);
    end

endmodule
