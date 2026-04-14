`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] nIn;
    wire [6:0] ssOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .nIn(nIn),
        .ssOut(ssOut)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input 0 (Zero)", test_num);
        nIn = 5'd0;
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input 5 (Digit 5)", test_num);
        nIn = 5'd5;
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input 9 (Digit 9)", test_num);
        nIn = 5'd9;
        #1;

        check_outputs(7'h6F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input 10 (Letter A)", test_num);
        nIn = 5'd10;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input 13 (Letter d)", test_num);
        nIn = 5'd13;
        #1;

        check_outputs(7'h5E);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Input 15 (Letter F)", test_num);
        nIn = 5'd15;
        #1;

        check_outputs(7'h71);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Input 16 (Custom Pattern H)", test_num);
        nIn = 5'd16;
        #1;

        check_outputs(7'h76);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Input 19 (Custom Pattern U)", test_num);
        nIn = 5'd19;
        #1;

        check_outputs(7'h3E);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Input 20 (Unsupported/Default)", test_num);
        nIn = 5'd20;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Input 31 (Max Value/Default)", test_num);
        nIn = 5'd31;
        #1;

        check_outputs(7'h00);
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
        input [6:0] expected_ssOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ssOut === (expected_ssOut ^ ssOut ^ expected_ssOut)) begin
                $display("PASS");
                $display("  Outputs: ssOut=%h",
                         ssOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ssOut=%h",
                         expected_ssOut);
                $display("  Got:      ssOut=%h",
                         ssOut);
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
