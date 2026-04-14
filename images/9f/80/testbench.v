`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] scan_code1;
    wire [15:0] sound1;
    wire sound_off1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .scan_code1(scan_code1),
        .sound1(sound1),
        .sound_off1(sound_off1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Testing sound_off signal for code 8'hf0", test_num);
        scan_code1 = 8'hf0;

        #1;


        check_outputs(16'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Testing Note C (8'h1c)", test_num);
        scan_code1 = 8'h1c;
        #1;

        check_outputs(16'd262, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Testing Note D (8'h1b)", test_num);
        scan_code1 = 8'h1b;
        #1;

        check_outputs(16'd294, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Testing Note E (8'h23)", test_num);
        scan_code1 = 8'h23;
        #1;

        check_outputs(16'd330, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Testing Note F (8'h2b)", test_num);
        scan_code1 = 8'h2b;
        #1;

        check_outputs(16'd349, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Testing Note G (8'h34)", test_num);
        scan_code1 = 8'h34;
        #1;

        check_outputs(16'd392, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Testing Note A (8'h33)", test_num);
        scan_code1 = 8'h33;
        #1;

        check_outputs(16'd440, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Testing Note B (8'h3b)", test_num);
        scan_code1 = 8'h3b;
        #1;

        check_outputs(16'd494, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Testing High Note C (8'h42)", test_num);
        scan_code1 = 8'h42;
        #1;

        check_outputs(16'd523, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Testing undefined scan code (8'h00)", test_num);
        scan_code1 = 8'h00;

        #1;


        check_outputs(16'd0, 1'b0);
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
        input [15:0] expected_sound1;
        input expected_sound_off1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sound1 === (expected_sound1 ^ sound1 ^ expected_sound1) &&
                expected_sound_off1 === (expected_sound_off1 ^ sound_off1 ^ expected_sound_off1)) begin
                $display("PASS");
                $display("  Outputs: sound1=%h, sound_off1=%b",
                         sound1, sound_off1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sound1=%h, sound_off1=%b",
                         expected_sound1, expected_sound_off1);
                $display("  Got:      sound1=%h, sound_off1=%b",
                         sound1, sound_off1);
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
