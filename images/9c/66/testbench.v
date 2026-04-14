`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dist_signal;
    reg [7:0] ref_signal;
    wire [7:0] eq_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dist_signal(dist_signal),
        .ref_signal(ref_signal),
        .eq_signal(eq_signal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All signals zero", test_num);
        dist_signal = 8'h00;
        ref_signal = 8'h00;
        #100;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Unity Gain (Distorted == Reference)", test_num);
        dist_signal = 8'h40;
        ref_signal = 8'h40;
        #500;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Amplification (Ref > Dist)", test_num);
        dist_signal = 8'h20;
        ref_signal = 8'h60;
        #1000;
        #1;

        check_outputs(8'h60);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Attenuation (Ref < Dist)", test_num);
        dist_signal = 8'hA0;
        ref_signal = 8'h50;
        #1000;
        #1;

        check_outputs(8'h50);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Scale Adaptation", test_num);
        dist_signal = 8'h7F;
        ref_signal = 8'hFE;
        #2000;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Convergence to Zero", test_num);
        dist_signal = 8'hFF;
        ref_signal = 8'h00;
        #1000;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_eq_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq_signal === (expected_eq_signal ^ eq_signal ^ expected_eq_signal)) begin
                $display("PASS");
                $display("  Outputs: eq_signal=%h",
                         eq_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq_signal=%h",
                         expected_eq_signal);
                $display("  Got:      eq_signal=%h",
                         eq_signal);
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
