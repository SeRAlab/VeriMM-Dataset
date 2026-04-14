`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] iData;
    reg iEna;
    wire [31:0] decode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iData(iData),
        .iEna(iEna),
        .decode(decode)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: iEna=0, iData=0. All outputs should be 0.");
        iEna = 1'b0;
        iData = 5'd0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: iEna=0, iData=31. All outputs should be 0.");
        iEna = 1'b0;
        iData = 5'd31;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: iEna=1, iData=0. Bit 0 should be HIGH.");
        iEna = 1'b1;
        iData = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: iEna=1, iData=1. Bit 1 should be HIGH.");
        iEna = 1'b1;
        iData = 5'd1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: iEna=1, iData=15. Bit 15 should be HIGH.");
        iEna = 1'b1;
        iData = 5'd15;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: iEna=1, iData=16. Bit 16 should be HIGH.");
        iEna = 1'b1;
        iData = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: iEna=1, iData=30. Bit 30 should be HIGH.");
        iEna = 1'b1;
        iData = 5'd30;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: iEna=1, iData=31. Bit 31 should be HIGH.");
        iEna = 1'b1;
        iData = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Check transition from iEna=1 to iEna=0.");
        iEna = 1'b1;
        iData = 5'd7;
        #1;
        iEna = 1'b0;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_decode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decode === (expected_decode ^ decode ^ expected_decode)) begin
                $display("PASS");
                $display("  Outputs: decode=%h",
                         decode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decode=%h",
                         expected_decode);
                $display("  Got:      decode=%h",
                         decode);
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
