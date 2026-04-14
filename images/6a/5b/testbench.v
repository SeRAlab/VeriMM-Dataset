`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg in[0];
    reg in[1];
    reg in[2];
    reg in[3];
    wire cout;
    wire lut4_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .in[0](in[0]),
        .in[1](in[1]),
        .in[2](in[2]),
        .in[3](in[3]),
        .cout(cout),
        .lut4_out(lut4_out)
    );
    task drive_and_check;

        input i3; input i2; input i1; input i0; input c_in;
        input exp_lut; input exp_cout;
        begin
            in[3] = i3; in[2] = i2; in[1] = i1; in[0] = i0; cin = c_in;
            #10;
            #1;

            check_outputs(exp_cout, exp_lut);
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: 0 + 0 + cin=0");
        drive_and_check(0, 0, 0, 0, 0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: 0 + 0 + cin=1");
        drive_and_check(0, 0, 0, 0, 1, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: 0 + 1 + cin=0");
        drive_and_check(0, 0, 0, 1, 0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: 1 + 0 + cin=0");
        drive_and_check(0, 0, 1, 0, 0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: 1 + 1 + cin=0 (Carry Generate)");
        drive_and_check(0, 0, 1, 1, 0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: 0 + 1 + cin=1 (Carry Propagate)");
        drive_and_check(0, 0, 0, 1, 1, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: 1 + 0 + cin=1 (Carry Propagate)");
        drive_and_check(0, 0, 1, 0, 1, 1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: 1 + 1 + cin=1");
        drive_and_check(0, 0, 1, 1, 1, 1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: Verifying auxiliary inputs in[2], in[3] stability");
        drive_and_check(1, 1, 0, 1, 0, 1'b1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: transition to Carry high with auxiliary inputs");
        drive_and_check(1, 0, 1, 1, 0, 1'b0, 1'b1);
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
        input expected_cout;
        input expected_lut4_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_lut4_out === (expected_lut4_out ^ lut4_out ^ expected_lut4_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, lut4_out=%b",
                         cout, lut4_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, lut4_out=%b",
                         expected_cout, expected_lut4_out);
                $display("  Got:      cout=%b, lut4_out=%b",
                         cout, lut4_out);
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
