`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] block;
    reg [10:0] fnum;
    reg [8:0] pm_offset;
    wire [16:0] phinc_pure;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .block(block),
        .fnum(fnum),
        .pm_offset(pm_offset),
        .phinc_pure(phinc_pure)
    );
    task testcase001;

        begin
            test_num = 1;
            block = 3'b000;
            fnum = 11'h000;
            pm_offset = 9'h000;

            #1;


            check_outputs(17'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            block = 3'b001;
            fnum = 11'h000;
            pm_offset = 9'h000;

            #1;


            check_outputs(17'h08000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            block = 3'b000;
            fnum = 11'h001;
            pm_offset = 9'h000;

            #1;


            check_outputs(17'h00008);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            block = 3'b000;
            fnum = 11'h000;
            pm_offset = 9'h001;

            #1;


            check_outputs(17'h00008);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            block = 3'b010;
            fnum = 11'h064;
            pm_offset = 9'h1FF;



            #1;




            check_outputs(17'h10318);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            block = 3'b111;
            fnum = 11'h7FF;
            pm_offset = 9'h000;

            #1;


            check_outputs(17'h1FFF8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            block = 3'b000;
            fnum = 11'h001;
            pm_offset = 9'h07F;

            #1;


            check_outputs(17'h00400);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            block = 3'b100;
            fnum = 11'h400;
            pm_offset = 9'h100;



            #1;




            check_outputs(17'h11800);
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
        input [16:0] expected_phinc_pure;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_phinc_pure === (expected_phinc_pure ^ phinc_pure ^ expected_phinc_pure)) begin
                $display("PASS");
                $display("  Outputs: phinc_pure=%h",
                         phinc_pure);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phinc_pure=%h",
                         expected_phinc_pure);
                $display("  Got:      phinc_pure=%h",
                         phinc_pure);
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
