`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] bin;
    wire [11:0] BCD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .BCD(BCD)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 0", test_num);
            bin = 10'd0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 7", test_num);
            bin = 10'd7;
            #1;

            check_outputs(12'h007);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 10", test_num);
            bin = 10'd10;
            #1;

            check_outputs(12'h010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 45", test_num);
            bin = 10'd45;
            #1;

            check_outputs(12'h045);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 99", test_num);
            bin = 10'd99;
            #1;

            check_outputs(12'h099);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 100", test_num);
            bin = 10'd100;
            #1;

            check_outputs(12'h100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 255", test_num);
            bin = 10'd255;
            #1;

            check_outputs(12'h255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 482", test_num);
            bin = 10'd482;
            #1;

            check_outputs(12'h482);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 819", test_num);
            bin = 10'd819;
            #1;

            check_outputs(12'h819);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 999", test_num);
            bin = 10'd999;
            #1;

            check_outputs(12'h999);
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
        input [11:0] expected_BCD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BCD === (expected_BCD ^ BCD ^ expected_BCD)) begin
                $display("PASS");
                $display("  Outputs: BCD=%h",
                         BCD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD=%h",
                         expected_BCD);
                $display("  Got:      BCD=%h",
                         BCD);
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
