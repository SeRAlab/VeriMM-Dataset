`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dp;
    reg en;
    reg [3:0] num;
    reg sign;
    wire [7:0] hex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dp(dp),
        .en(en),
        .num(num),
        .sign(sign),
        .hex(hex)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable signal low (Display OFF)", test_num);
            en = 1'b0;
            dp = 1'b1;
            sign = 1'b0;
            num = 4'hF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign active, DP off", test_num);
            en = 1'b1;
            dp = 1'b0;
            sign = 1'b1;
            num = 4'h5;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign active, DP on", test_num);
            en = 1'b1;
            dp = 1'b1;
            sign = 1'b1;
            num = 4'h0;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Decode digit 0, DP off", test_num);
            en = 1'b1;
            dp = 1'b0;
            sign = 1'b0;
            num = 4'h0;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Decode digit 7, DP on", test_num);
            en = 1'b1;
            dp = 1'b1;
            sign = 1'b0;
            num = 4'h7;
            #1;

            check_outputs(8'h87);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Decode digit A, DP off", test_num);
            en = 1'b1;
            dp = 1'b0;
            sign = 1'b0;
            num = 4'hA;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Decode digit F, DP on", test_num);
            en = 1'b1;
            dp = 1'b1;
            sign = 1'b0;
            num = 4'hF;
            #1;

            check_outputs(8'hF1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Decode digit 8, DP off", test_num);
            en = 1'b1;
            dp = 1'b0;
            sign = 1'b0;
            num = 4'h8;
            #1;

            check_outputs(8'h7F);
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
        input [7:0] expected_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex === (expected_hex ^ hex ^ expected_hex)) begin
                $display("PASS");
                $display("  Outputs: hex=%h",
                         hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex=%h",
                         expected_hex);
                $display("  Got:      hex=%h",
                         hex);
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
