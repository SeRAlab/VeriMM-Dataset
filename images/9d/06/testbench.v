`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] dat_in;
    reg dot_in;
    reg en;
    wire [7:0] led_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dat_in(dat_in),
        .dot_in(dot_in),
        .en(en),
        .led_n(led_n)
    );
    task testcase001;

    begin
        $display("Running testcase001: Digits 0-3, en=1, dot=0");
        en = 1; dot_in = 0;

        test_num = test_num + 1; dat_in = 4'h0; #10; #1;
 check_outputs(8'hc0);
        test_num = test_num + 1; dat_in = 4'h1; #10; #1;
 check_outputs(8'hf9);
        test_num = test_num + 1; dat_in = 4'h2; #10; #1;
 check_outputs(8'ha4);
        test_num = test_num + 1; dat_in = 4'h3; #10; #1;
 check_outputs(8'hb0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Digits 4-7, en=1, dot=0");
        en = 1; dot_in = 0;

        test_num = test_num + 1; dat_in = 4'h4; #10; #1;
 check_outputs(8'h99);
        test_num = test_num + 1; dat_in = 4'h5; #10; #1;
 check_outputs(8'h92);
        test_num = test_num + 1; dat_in = 4'h6; #10; #1;
 check_outputs(8'h82);
        test_num = test_num + 1; dat_in = 4'h7; #10; #1;
 check_outputs(8'hf8);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Digits 8-B, en=1, dot=1");
        en = 1; dot_in = 1;

        test_num = test_num + 1; dat_in = 4'h8; #10; #1;
 check_outputs(8'h00);
        test_num = test_num + 1; dat_in = 4'h9; #10; #1;
 check_outputs(8'h10);
        test_num = test_num + 1; dat_in = 4'ha; #10; #1;
 check_outputs(8'h08);
        test_num = test_num + 1; dat_in = 4'hb; #10; #1;
 check_outputs(8'h03);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Digits C-F, en=1, dot=1");
        en = 1; dot_in = 1;

        test_num = test_num + 1; dat_in = 4'hc; #10; #1;
 check_outputs(8'h46);
        test_num = test_num + 1; dat_in = 4'hd; #10; #1;
 check_outputs(8'h21);
        test_num = test_num + 1; dat_in = 4'he; #10; #1;
 check_outputs(8'h06);
        test_num = test_num + 1; dat_in = 4'hf; #10; #1;
 check_outputs(8'h0e);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Disable mode, en=0");
        en = 0; dat_in = 4'hA;

        test_num = test_num + 1; dot_in = 0; #10; #1;
 check_outputs(8'hff);
        test_num = test_num + 1; dot_in = 1; #10; #1;
 check_outputs(8'h7f);
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
        input [7:0] expected_led_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led_n === (expected_led_n ^ led_n ^ expected_led_n)) begin
                $display("PASS");
                $display("  Outputs: led_n=%h",
                         led_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_n=%h",
                         expected_led_n);
                $display("  Got:      led_n=%h",
                         led_n);
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
