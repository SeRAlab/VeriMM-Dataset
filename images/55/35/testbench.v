`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] FPReadData;
    reg [63:0] ReadData;
    reg floatop;
    wire [63:0] RegData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FPReadData(FPReadData),
        .ReadData(ReadData),
        .floatop(floatop),
        .RegData(RegData)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select ReadData (floatop=0)", test_num);
            ReadData   = 64'hAAAA_AAAA_AAAA_AAAA;
            FPReadData = 64'h5555_5555_5555_5555;
            floatop    = 1'b0;
            #1;

            check_outputs(64'hAAAA_AAAA_AAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select FPReadData (floatop=1)", test_num);
            ReadData   = 64'hAAAA_AAAA_AAAA_AAAA;
            FPReadData = 64'h5555_5555_5555_5555;
            floatop    = 1'b1;
            #1;

            check_outputs(64'h5555_5555_5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Check ReadData", test_num);
            ReadData   = 64'hFEDC_BA98_7654_3210;
            FPReadData = 64'h0123_4567_89AB_CDEF;
            floatop    = 1'b0;
            #1;

            check_outputs(64'hFEDC_BA98_7654_3210);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Check FPReadData", test_num);
            ReadData   = 64'hFEDC_BA98_7654_3210;
            FPReadData = 64'h0123_4567_89AB_CDEF;
            floatop    = 1'b1;
            #1;

            check_outputs(64'h0123_4567_89AB_CDEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Condition All Zeros", test_num);
            ReadData   = 64'h0000_0000_0000_0000;
            FPReadData = 64'hFFFF_FFFF_FFFF_FFFF;
            floatop    = 1'b0;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Condition All Ones", test_num);
            ReadData   = 64'h0000_0000_0000_0000;
            FPReadData = 64'hFFFF_FFFF_FFFF_FFFF;
            floatop    = 1'b1;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
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
        input [63:0] expected_RegData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RegData === (expected_RegData ^ RegData ^ expected_RegData)) begin
                $display("PASS");
                $display("  Outputs: RegData=%h",
                         RegData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegData=%h",
                         expected_RegData);
                $display("  Got:      RegData=%h",
                         RegData);
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
