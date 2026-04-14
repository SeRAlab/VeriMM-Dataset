`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] sig_keyboard;
    wire [3:0] bin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sig_keyboard(sig_keyboard),
        .bin(bin)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input Scan Code 0x45 (Key 0)", test_num);
        sig_keyboard = 9'h045;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input Scan Code 0x16 (Key 1)", test_num);
        sig_keyboard = 9'h016;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input Scan Code 0x1E (Key 2)", test_num);
        sig_keyboard = 9'h01E;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input Scan Code 0x26 (Key 3)", test_num);
        sig_keyboard = 9'h026;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input Scan Code 0x25 (Key 4)", test_num);
        sig_keyboard = 9'h025;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input Scan Code 0x2E (Key 5)", test_num);
        sig_keyboard = 9'h02E;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input Scan Code 0x36 (Key 6)", test_num);
        sig_keyboard = 9'h036;
        #1;

        check_outputs(4'h6);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input Scan Code 0x3D (Key 7)", test_num);
        sig_keyboard = 9'h03D;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Input Scan Code 0x3E (Key 8)", test_num);
        sig_keyboard = 9'h03E;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Input Scan Code 0x46 (Key 9)", test_num);
        sig_keyboard = 9'h046;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Input Undefined Code 0x1FF", test_num);
        sig_keyboard = 9'h1FF;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Input Undefined Code 0x000", test_num);
        sig_keyboard = 9'h000;
        #1;

        check_outputs(4'hF);
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
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_bin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bin === (expected_bin ^ bin ^ expected_bin)) begin
                $display("PASS");
                $display("  Outputs: bin=%h",
                         bin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bin=%h",
                         expected_bin);
                $display("  Got:      bin=%h",
                         bin);
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
