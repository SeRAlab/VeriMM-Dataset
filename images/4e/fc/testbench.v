`timescale 1ns/1ps

module shift_left_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg enable;
    reg reset;
    wire [7:0] shift_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_left_module dut (
        .a(a),
        .enable(enable),
        .reset(reset),
        .shift_result(shift_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset - Reset should clear output", test_num);
            reset = 1;
            enable = 1;
            a = 8'hFF;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 0x01 - Small value", test_num);
            reset = 1; #5; reset = 0;
            a = 8'h01;
            enable = 1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 0x80 - MSB overflow check", test_num);
            reset = 1; #5; reset = 0;
            a = 8'h80;
            enable = 1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 0x55 - Alternating bits check", test_num);
            reset = 1; #5; reset = 0;
            a = 8'h55;
            enable = 1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 0xFF - Full scale check", test_num);
            reset = 1; #5; reset = 0;
            a = 8'hFF;
            enable = 1;

            #1;


            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority - Reset overrides Enable", test_num);
            reset = 1; #5; reset = 0;
            a = 8'h0A;
            enable = 1;
            #2;
            reset = 1;

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
        $display("shift_left_module Testbench");
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
        input [7:0] expected_shift_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shift_result === (expected_shift_result ^ shift_result ^ expected_shift_result)) begin
                $display("PASS");
                $display("  Outputs: shift_result=%h",
                         shift_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_result=%h",
                         expected_shift_result);
                $display("  Got:      shift_result=%h",
                         shift_result);
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
