`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] bin;
    wire [15:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .gray(gray)
    );
    task testcase001;

    begin
        test_num = 1;
        bin = 16'h0000;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bin = 16'hFFFF;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bin = 16'h8000;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'hC000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bin = 16'h0001;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bin = 16'h0002;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'h0003);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bin = 16'h0003;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bin = 16'hAAAA;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bin = 16'h5555;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bin = 16'h7FFF;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bin = 16'h1234;
        $display("Test %0d: Binary input = %h", test_num, bin);
        #1;

        check_outputs(16'h1B2E);
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
        input [15:0] expected_gray;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
