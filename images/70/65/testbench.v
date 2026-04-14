`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg iDVAL;
    reg iFrameCount;
    reg [11:0] iGray;
    wire oDVAL1;
    wire oDVAL2;
    wire [11:0] oGray1;
    wire [11:0] oGray2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iDVAL(iDVAL),
        .iFrameCount(iFrameCount),
        .iGray(iGray),
        .oDVAL1(oDVAL1),
        .oDVAL2(oDVAL2),
        .oGray1(oGray1),
        .oGray2(oGray2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: iFrameCount=1, iDVAL=1, iGray=12'hA5A", test_num);
            iFrameCount = 1'b1;
            iDVAL = 1'b1;
            iGray = 12'hA5A;

            #1;


            check_outputs(1'b1, 1'b0, 12'hA5A, 12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: iFrameCount=0, iDVAL=1, iGray=12'h5A5", test_num);
            iFrameCount = 1'b0;
            iDVAL = 1'b1;
            iGray = 12'h5A5;

            #1;


            check_outputs(1'b0, 1'b1, 12'h000, 12'h5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: iFrameCount=1, iDVAL=0, iGray=12'hFFF", test_num);
            iFrameCount = 1'b1;
            iDVAL = 1'b0;
            iGray = 12'hFFF;

            #1;


            check_outputs(1'b0, 1'b0, 12'hFFF, 12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: iFrameCount=0, iDVAL=0, iGray=12'h123", test_num);
            iFrameCount = 1'b0;
            iDVAL = 1'b0;
            iGray = 12'h123;

            #1;


            check_outputs(1'b0, 1'b0, 12'h000, 12'h123);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: iFrameCount=1, iDVAL=1, iGray=12'h800 (MSB Test)", test_num);
            iFrameCount = 1'b1;
            iDVAL = 1'b1;
            iGray = 12'h800;
            #1;

            check_outputs(1'b1, 1'b0, 12'h800, 12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: iFrameCount=0, iDVAL=1, iGray=12'h001 (LSB Test)", test_num);
            iFrameCount = 1'b0;
            iDVAL = 1'b1;
            iGray = 12'h001;
            #1;

            check_outputs(1'b0, 1'b1, 12'h000, 12'h001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Switching FrameCount with constant data", test_num);
            iGray = 12'hABC;
            iDVAL = 1'b1;

            iFrameCount = 1'b1;
            #2;
            $display("  Sub-test 7a: FrameCount=1");
            #1;

            check_outputs(1'b1, 1'b0, 12'hABC, 12'h000);

            iFrameCount = 1'b0;
            #2;
            $display("  Sub-test 7b: FrameCount=0");
            #1;

            check_outputs(1'b0, 1'b1, 12'h000, 12'hABC);
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
        input expected_oDVAL1;
        input expected_oDVAL2;
        input [11:0] expected_oGray1;
        input [11:0] expected_oGray2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oDVAL1 === (expected_oDVAL1 ^ oDVAL1 ^ expected_oDVAL1) &&
                expected_oDVAL2 === (expected_oDVAL2 ^ oDVAL2 ^ expected_oDVAL2) &&
                expected_oGray1 === (expected_oGray1 ^ oGray1 ^ expected_oGray1) &&
                expected_oGray2 === (expected_oGray2 ^ oGray2 ^ expected_oGray2)) begin
                $display("PASS");
                $display("  Outputs: oDVAL1=%b, oDVAL2=%b, oGray1=%h, oGray2=%h",
                         oDVAL1, oDVAL2, oGray1, oGray2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oDVAL1=%b, oDVAL2=%b, oGray1=%h, oGray2=%h",
                         expected_oDVAL1, expected_oDVAL2, expected_oGray1, expected_oGray2);
                $display("  Got:      oDVAL1=%b, oDVAL2=%b, oGray1=%h, oGray2=%h",
                         oDVAL1, oDVAL2, oGray1, oGray2);
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
