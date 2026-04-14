`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk100;
    reg rst;
    wire AN;
    wire CA;
    wire CB;
    wire CC;
    wire CD;
    wire CE;
    wire CF;
    wire CG;
    wire DP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk100(clk100),
        .rst(rst),
        .AN(AN),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG),
        .DP(DP)
    );
    task testcase001;

        begin
            $display("Testcase 001: Reset and Initial Check");
            test_num = 1;

            rst = 1;
            clk100 = 0;
            #20;

            rst = 0;
            #10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Clock Activity Check");
            test_num = 2;

            rst = 1;
            #10;
            rst = 0;

            repeat (5) begin
                clk100 = 1; #5;
                clk100 = 0; #5;
            end

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Post-Reset Persistence");
            test_num = 3;

            rst = 0;
            clk100 = 0;
            #50;
            rst = 1;
            #20;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_AN;
        input expected_CA;
        input expected_CB;
        input expected_CC;
        input expected_CD;
        input expected_CE;
        input expected_CF;
        input expected_CG;
        input expected_DP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AN === (expected_AN ^ AN ^ expected_AN) &&
                expected_CA === (expected_CA ^ CA ^ expected_CA) &&
                expected_CB === (expected_CB ^ CB ^ expected_CB) &&
                expected_CC === (expected_CC ^ CC ^ expected_CC) &&
                expected_CD === (expected_CD ^ CD ^ expected_CD) &&
                expected_CE === (expected_CE ^ CE ^ expected_CE) &&
                expected_CF === (expected_CF ^ CF ^ expected_CF) &&
                expected_CG === (expected_CG ^ CG ^ expected_CG) &&
                expected_DP === (expected_DP ^ DP ^ expected_DP)) begin
                $display("PASS");
                $display("  Outputs: AN=%b, CA=%b, CB=%b, CC=%b, CD=%b, CE=%b, CF=%b, CG=%b, DP=%b",
                         AN, CA, CB, CC, CD, CE, CF, CG, DP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AN=%b, CA=%b, CB=%b, CC=%b, CD=%b, CE=%b, CF=%b, CG=%b, DP=%b",
                         expected_AN, expected_CA, expected_CB, expected_CC, expected_CD, expected_CE, expected_CF, expected_CG, expected_DP);
                $display("  Got:      AN=%b, CA=%b, CB=%b, CC=%b, CD=%b, CE=%b, CF=%b, CG=%b, DP=%b",
                         AN, CA, CB, CC, CD, CE, CF, CG, DP);
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
