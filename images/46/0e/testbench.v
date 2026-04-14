`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] NumIn;
    wire [31:0] Num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .NumIn(NumIn),
        .Num(Num)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 0 (Zero)", test_num);
        NumIn = 32'd0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 9 (Single Digit Boundary)", test_num);
        NumIn = 32'd9;
        #1;

        check_outputs(32'h9);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 10 (Double Digit Boundary)", test_num);
        NumIn = 32'd10;
        #1;

        check_outputs(32'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 42", test_num);
        NumIn = 32'd42;
        #1;

        check_outputs(32'h42);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 99 (Double Digit Max)", test_num);
        NumIn = 32'd99;
        #1;

        check_outputs(32'h99);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 100 (Triple Digit Boundary)", test_num);
        NumIn = 32'd100;
        #1;

        check_outputs(32'h100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 1024", test_num);
        NumIn = 32'd1024;
        #1;

        check_outputs(32'h1024);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 65535", test_num);
        NumIn = 32'd65535;
        #1;

        check_outputs(32'h65535);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 12345678", test_num);
        NumIn = 32'd12345678;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 99999999 (8-Digit Max BCD)", test_num);
        NumIn = 32'd99999999;
        #1;

        check_outputs(32'h99999999);
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
        input [31:0] expected_Num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Num === (expected_Num ^ Num ^ expected_Num)) begin
                $display("PASS");
                $display("  Outputs: Num=%h",
                         Num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Num=%h",
                         expected_Num);
                $display("  Got:      Num=%h",
                         Num);
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
