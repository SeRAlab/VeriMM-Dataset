`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] subResult;
    wire equalOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .subResult(subResult),
        .equalOut(equalOut)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: subResult = 0x00000000", test_num);
        subResult = 32'h0000_0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: subResult = 0x00000001 (LSB)", test_num);
        subResult = 32'h0000_0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: subResult = 0x80000000 (MSB)", test_num);
        subResult = 32'h8000_0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: subResult = 0xFFFFFFFF (All ones)", test_num);
        subResult = 32'hFFFF_FFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: subResult = 0x00010000", test_num);
        subResult = 32'h0001_0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: subResult = 0x0000000F", test_num);
        subResult = 32'h0000_000F;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: subResult = 0xAAAAAAAA", test_num);
        subResult = 32'hAAAA_AAAA;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: subResult = 0x00008000", test_num);
        subResult = 32'h0000_8000;
        #1;

        check_outputs(1'b1);
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
        input expected_equalOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equalOut === (expected_equalOut ^ equalOut ^ expected_equalOut)) begin
                $display("PASS");
                $display("  Outputs: equalOut=%b",
                         equalOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equalOut=%b",
                         expected_equalOut);
                $display("  Got:      equalOut=%b",
                         equalOut);
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
