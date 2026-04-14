`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [35:0] preIntegrator;
    reg [35:0] preSat;
    reg saturated;
    wire Clamp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .preIntegrator(preIntegrator),
        .preSat(preSat),
        .saturated(saturated),
        .Clamp(Clamp)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All conditions met (Negative, Negative, Saturated)", test_num);
        preIntegrator = 36'hF_FFFF_FFFF;
        preSat = 36'hF_FFFF_FF00;
        saturated = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Non-positive boundaries (Zero, Zero, Saturated)", test_num);
        preIntegrator = 36'h0_0000_0000;
        preSat = 36'h0_0000_0000;
        saturated = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Saturated deasserted", test_num);
        preIntegrator = 36'hF_FFFF_FFFF;
        preSat = 36'hF_FFFF_FFFF;
        saturated = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: preIntegrator positive, preSat negative", test_num);
        preIntegrator = 36'h0_0000_0001;
        preSat = 36'hF_FFFF_FFFF;
        saturated = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: preIntegrator negative, preSat positive", test_num);
        preIntegrator = 36'hF_FFFF_FFFF;
        preSat = 36'h0_0000_0005;
        saturated = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Both values positive", test_num);
        preIntegrator = 36'h0_0000_1234;
        preSat = 36'h0_0000_5678;
        saturated = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative and Zero, Saturated", test_num);
        preIntegrator = 36'h8_0000_0000;
        preSat = 36'h0_0000_0000;
        saturated = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max positive values", test_num);
        preIntegrator = 36'h7_FFFF_FFFF;
        preSat = 36'h7_FFFF_FFFF;
        saturated = 1'b1;
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
        testcase007();
        testcase008();
        
        
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
        input expected_Clamp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Clamp === (expected_Clamp ^ Clamp ^ expected_Clamp)) begin
                $display("PASS");
                $display("  Outputs: Clamp=%b",
                         Clamp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Clamp=%b",
                         expected_Clamp);
                $display("  Got:      Clamp=%b",
                         Clamp);
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
