`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] linear_enc_sign;
    reg sign;
    wire [11:0] conv_sig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .linear_enc_sign(linear_enc_sign),
        .sign(sign),
        .conv_sig(conv_sig)
    );
    task testcase001;

    begin
        test_num = 1;
        sign = 0;
        linear_enc_sign = 12'h000;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        sign = 0;
        linear_enc_sign = 12'hABC;
        #1;

        check_outputs(12'hABC);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        sign = 0;
        linear_enc_sign = 12'hFFF;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        sign = 1;
        linear_enc_sign = 12'h000;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        sign = 1;
        linear_enc_sign = 12'h001;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        sign = 1;
        linear_enc_sign = 12'h002;
        #1;

        check_outputs(12'hFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        sign = 1;
        linear_enc_sign = 12'h800;
        #1;

        check_outputs(12'h7FF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        sign = 1;
        linear_enc_sign = 12'h7FF;
        #1;

        check_outputs(12'h801);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        sign = 1;
        linear_enc_sign = 12'h00A;
        #1;

        check_outputs(12'hFF6);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        sign = 1;
        linear_enc_sign = 12'hFFF;
        #1;

        check_outputs(12'h001);
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
        input [11:0] expected_conv_sig;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_conv_sig === (expected_conv_sig ^ conv_sig ^ expected_conv_sig)) begin
                $display("PASS");
                $display("  Outputs: conv_sig=%h",
                         conv_sig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: conv_sig=%h",
                         expected_conv_sig);
                $display("  Got:      conv_sig=%h",
                         conv_sig);
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
