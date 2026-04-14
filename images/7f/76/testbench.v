`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC0;
    wire [31:0] PC4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC0(PC0),
        .PC4(PC4)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: PC0 = 0", test_num);
        PC0 = 32'h0000_0000;
        #1;

        check_outputs(32'h0000_0004);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Typical address 0x00001000", test_num);
        PC0 = 32'h0000_1000;
        #1;

        check_outputs(32'h0000_1004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Large address 0x12345678", test_num);
        PC0 = 32'h1234_5678;
        #1;

        check_outputs(32'h1234_567C);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum aligned address overflow check", test_num);
        PC0 = 32'hFFFF_FFFC;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Unaligned address 0x00000002", test_num);
        PC0 = 32'h0000_0002;
        #1;

        check_outputs(32'h0000_0006);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Max 32-bit value PC0 = 0xFFFFFFFF", test_num);
        PC0 = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h0000_0003);
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
        input [31:0] expected_PC4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PC4 === (expected_PC4 ^ PC4 ^ expected_PC4)) begin
                $display("PASS");
                $display("  Outputs: PC4=%h",
                         PC4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC4=%h",
                         expected_PC4);
                $display("  Got:      PC4=%h",
                         PC4);
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
