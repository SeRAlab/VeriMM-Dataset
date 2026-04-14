`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg [7:0] eo;
    reg [47:0] mo;
    wire [7:0] eout;
    wire [22:0] mout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .eo(eo),
        .mo(mo),
        .eout(eout),
        .mout(mout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: EN=0 (Output should be eout=0, mout=mo[22:0])", test_num);
            EN = 0;
            eo = 8'hA5;
            mo = 48'hFEDCBA_987654;

            #1;


            check_outputs(8'h00, 23'h187654);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: EN=1, mo[47]=1 (eout=eo+1, mout=mo[46:24])", test_num);
            EN = 1;
            eo = 8'h10;

            mo = {1'b1, 23'h555555, 24'h000000};

            #1;


            check_outputs(8'h11, 23'h555555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: EN=1, mo[47]=0 (eout=eo, mout=mo[45:23])", test_num);
            EN = 1;
            eo = 8'h20;

            mo = {1'b0, 1'b1, 23'h333333, 23'h0};

            #1;


            check_outputs(8'h20, 23'h333333);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: EN=1, mo[47]=1, Overflow Exponent Check (eo=FF)", test_num);
            EN = 1;
            eo = 8'hFF;

            mo = 48'hFFFFFFFFFFFF;

            #1;


            check_outputs(8'h00, 23'h7FFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: EN=0, All Bits Set", test_num);
            EN = 0;
            eo = 8'hFF;
            mo = 48'hFFFFFFFFFFFF;

            #1;


            check_outputs(8'h00, 23'h7FFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: EN=1, mo[47]=0, Low bits logic check", test_num);
            EN = 1;
            eo = 8'h7F;

            mo = 48'h000000_FFFFFF;

            #1;


            check_outputs(8'h7F, 23'h000001);
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
        input [7:0] expected_eout;
        input [22:0] expected_mout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eout === (expected_eout ^ eout ^ expected_eout) &&
                expected_mout === (expected_mout ^ mout ^ expected_mout)) begin
                $display("PASS");
                $display("  Outputs: eout=%h, mout=%h",
                         eout, mout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eout=%h, mout=%h",
                         expected_eout, expected_mout);
                $display("  Got:      eout=%h, mout=%h",
                         eout, mout);
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
