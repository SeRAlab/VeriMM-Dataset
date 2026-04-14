`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dp;
    reg [3:0] hex_in;
    wire [6:0] sseg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dp(dp),
        .hex_in(hex_in),
        .sseg(sseg)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: hex_in=0, dp=0", test_num);
        hex_in = 4'h0;
        dp = 0;
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: hex_in=1, dp=0", test_num);
        hex_in = 4'h1;
        dp = 0;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: hex_in=2, dp=0", test_num);
        hex_in = 4'h2;
        dp = 0;
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: hex_in=3, dp=0", test_num);
        hex_in = 4'h3;
        dp = 0;
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: hex_in=4, dp=0", test_num);
        hex_in = 4'h4;
        dp = 0;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: hex_in=5, dp=0", test_num);
        hex_in = 4'h5;
        dp = 0;
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: hex_in=6, dp=0", test_num);
        hex_in = 4'h6;
        dp = 0;
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: hex_in=7, dp=0", test_num);
        hex_in = 4'h7;
        dp = 0;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: hex_in=8, dp=0", test_num);
        hex_in = 4'h8;
        dp = 0;
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: hex_in=9, dp=0", test_num);
        hex_in = 4'h9;
        dp = 0;
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: hex_in=A, dp=0", test_num);
        hex_in = 4'hA;
        dp = 0;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: hex_in=B, dp=0", test_num);
        hex_in = 4'hB;
        dp = 0;
        #1;

        check_outputs(7'h7c);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: hex_in=C, dp=0", test_num);
        hex_in = 4'hC;
        dp = 0;
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %0d: hex_in=D, dp=0", test_num);
        hex_in = 4'hD;
        dp = 0;
        #1;

        check_outputs(7'h5e);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %0d: hex_in=E, dp=0", test_num);
        hex_in = 4'hE;
        dp = 0;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %0d: hex_in=F, dp=0", test_num);
        hex_in = 4'hF;
        dp = 0;
        #1;

        check_outputs(7'h71);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        $display("Testcase %0d: hex_in=0, dp=1", test_num);
        hex_in = 4'h0;
        dp = 1;
        #1;

        check_outputs(7'h3f);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        
        
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
        input [6:0] expected_sseg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sseg === (expected_sseg ^ sseg ^ expected_sseg)) begin
                $display("PASS");
                $display("  Outputs: sseg=%h",
                         sseg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sseg=%h",
                         expected_sseg);
                $display("  Got:      sseg=%h",
                         sseg);
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
