`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] d;
    reg wrenable;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .wrenable(wrenable),
        .q(q)
    );
    task testcase001;

        begin

            clk = 0;
            d = 32'h0;
            wrenable = 0;
            #10;

            test_num = test_num + 1;
            $display("Test Case %0d: Initial state check - All inputs zero", test_num);

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin

            clk = 0; d = 0; wrenable = 0; #10;

            test_num = test_num + 1;
            $display("Test Case %0d: Attempt to write all 1s with wrenable high", test_num);
            d = 32'hFFFFFFFF;
            wrenable = 1;
            #5 clk = 1; #5 clk = 0;
            #10;

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase003;

        begin

            clk = 0; d = 0; wrenable = 0; #10;

            test_num = test_num + 1;
            $display("Test Case %0d: Attempt to write alternating bit pattern", test_num);
            d = 32'hA5A5A5A5;
            wrenable = 1;
            #5 clk = 1; #5 clk = 0;
            #10;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase004;

        begin

            clk = 0; d = 0; wrenable = 0; #10;

            test_num = test_num + 1;
            $display("Test Case %0d: High data with wrenable low", test_num);
            d = 32'hFFFFFFFF;
            wrenable = 0;
            #5 clk = 1; #5 clk = 0;
            #10;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin

            clk = 0; d = 0; wrenable = 0; #10;

            test_num = test_num + 1;
            $display("Test Case %0d: Multiple clock cycles with varying data", test_num);
            wrenable = 1;
            d = 32'h11112222; #5 clk = 1; #5 clk = 0;
            d = 32'h33334444; #5 clk = 1; #5 clk = 0;
            d = 32'h55556666; #5 clk = 1; #5 clk = 0;
            d = 32'h77778888; #5 clk = 1; #5 clk = 0;
            #10;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin

            clk = 0; d = 0; wrenable = 0; #10;

            test_num = test_num + 1;
            $display("Test Case %0d: Verification of static LOW output without clock activity", test_num);
            d = 32'hDEADBEEF;
            wrenable = 1;
            #20;
            #1;

            check_outputs(32'h0);
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
        input [31:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
