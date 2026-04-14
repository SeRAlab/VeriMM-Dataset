`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] block;
    reg [2:0] detune;
    reg [10:0] fnum;
    wire [5:0] detune_signed;
    wire [4:0] keycode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .block(block),
        .detune(detune),
        .fnum(fnum),
        .detune_signed(detune_signed),
        .keycode(keycode)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros input", test_num);
        block = 3'd0;
        fnum = 11'd0;
        detune = 3'd0;
        #1;

        check_outputs(6'sd0, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max values for Keycode derivation", test_num);
        block = 3'd7;
        fnum = 11'h7FF;
        detune = 3'd3;
        #1;

        check_outputs(6'sd3, 5'd31);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative detune and middle fnum bits", test_num);
        block = 3'd4;
        fnum = 11'h400;
        detune = 3'd7;
        #1;

        check_outputs(6'sd-3, 5'd18);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small block and negative detune", test_num);
        block = 3'd1;
        fnum = 11'h200;
        detune = 3'd5;
        #1;

        check_outputs(6'sd-1, 5'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Detune transition value 4", test_num);
        block = 3'd3;
        fnum = 11'h600;
        detune = 3'd4;
        #1;

        check_outputs(6'sd0, 5'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Specific fnum bit check", test_num);
        block = 3'd5;
        fnum = 11'h3FF;
        detune = 3'd6;
        #1;

        check_outputs(6'sd-2, 5'd21);
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
        input [5:0] expected_detune_signed;
        input [4:0] expected_keycode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_detune_signed === (expected_detune_signed ^ detune_signed ^ expected_detune_signed) &&
                expected_keycode === (expected_keycode ^ keycode ^ expected_keycode)) begin
                $display("PASS");
                $display("  Outputs: detune_signed=%h, keycode=%h",
                         detune_signed, keycode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detune_signed=%h, keycode=%h",
                         expected_detune_signed, expected_keycode);
                $display("  Got:      detune_signed=%h, keycode=%h",
                         detune_signed, keycode);
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
