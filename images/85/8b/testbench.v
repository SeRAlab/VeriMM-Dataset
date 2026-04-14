`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio;
    reg [15:0] threshold;
    wire vad;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio(audio),
        .threshold(threshold),
        .vad(vad)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Audio > Threshold (Positive values)", test_num);
        audio = 16'sd1000;
        threshold = 16'sd500;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Audio < Threshold (Positive values)", test_num);
        audio = 16'sd250;
        threshold = 16'sd500;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Audio == Threshold (Positive values)", test_num);
        audio = 16'sd500;
        threshold = 16'sd500;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Audio > Threshold (Negative values)", test_num);
        audio = -16'sd100;
        threshold = -16'sd500;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Audio < Threshold (Negative values)", test_num);
        audio = -16'sd800;
        threshold = -16'sd500;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Audio Positive, Threshold Negative", test_num);
        audio = 16'sd10;
        threshold = -16'sd10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Audio Negative, Threshold Positive", test_num);
        audio = -16'sd10;
        threshold = 16'sd10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Positive Boundary", test_num);
        audio = 16'h7FFF;
        threshold = 16'h7FFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Min Negative Boundary", test_num);
        audio = 16'h8000;
        threshold = 16'h8001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero inputs", test_num);
        audio = 16'sd0;
        threshold = 16'sd0;
        #1;

        check_outputs(1'b1);
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
        testcase010();
        
        
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
        input expected_vad;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vad === (expected_vad ^ vad ^ expected_vad)) begin
                $display("PASS");
                $display("  Outputs: vad=%b",
                         vad);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vad=%b",
                         expected_vad);
                $display("  Got:      vad=%b",
                         vad);
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
