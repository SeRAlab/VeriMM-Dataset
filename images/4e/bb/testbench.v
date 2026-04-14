`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] adc_0;
    reg [17:0] adc_1;
    wire [17:0] phase_currents_0;
    wire [17:0] phase_currents_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_0(adc_0),
        .adc_1(adc_1),
        .phase_currents_0(phase_currents_0),
        .phase_currents_1(phase_currents_1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Inputs", test_num);
            adc_0 = 18'sh00000;
            adc_1 = 18'sh00000;

            #1;


            check_outputs(18'sh00000, 18'sh00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Positive Values", test_num);
            adc_0 = 18'sh00400;
            adc_1 = 18'sh00800;
            #1;

            check_outputs(18'sh00400, 18'sh00800);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Negative Values", test_num);
            adc_0 = 18'sh3FC00;
            adc_1 = 18'sh3F800;
            #1;

            check_outputs(18'sh3FC00, 18'sh3F800);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Full Scale", test_num);
            adc_0 = 18'h1FFFF;
            adc_1 = 18'h1FFFF;
            #1;

            check_outputs(18'h1FFFF, 18'h1FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Full Scale", test_num);
            adc_0 = 18'h20000;
            adc_1 = 18'h20000;
            #1;

            check_outputs(18'h20000, 18'h20000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Polarities", test_num);
            adc_0 = 18'h1AAAA;
            adc_1 = 18'h25555;
            #1;

            check_outputs(18'h1AAAA, 18'h25555);
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
        input [17:0] expected_phase_currents_0;
        input [17:0] expected_phase_currents_1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_phase_currents_0 === (expected_phase_currents_0 ^ phase_currents_0 ^ expected_phase_currents_0) &&
                expected_phase_currents_1 === (expected_phase_currents_1 ^ phase_currents_1 ^ expected_phase_currents_1)) begin
                $display("PASS");
                $display("  Outputs: phase_currents_0=%h, phase_currents_1=%h",
                         phase_currents_0, phase_currents_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_currents_0=%h, phase_currents_1=%h",
                         expected_phase_currents_0, expected_phase_currents_1);
                $display("  Got:      phase_currents_0=%h, phase_currents_1=%h",
                         phase_currents_0, phase_currents_1);
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

endmodule
