`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] HSV1;
    reg [31:0] HSV2;
    wire [31:0] outHSV;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HSV1(HSV1),
        .HSV2(HSV2),
        .outHSV(outHSV)
    );
    task testcase001;

        begin
            test_num = 1;
            HSV1 = 32'h001E50FF;
            HSV2 = 32'h001E50FF;

            #1;


            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            HSV1 = 32'h001E50FF;
            HSV2 = 32'h00F050FF;
            #1;

            check_outputs(32'h000000FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            HSV1 = 32'h001E05FF;
            HSV2 = 32'h001E50FF;
            #1;

            check_outputs(32'h0000FF00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            HSV1 = 32'h00FFFFFF;
            HSV2 = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            HSV1 = 32'h00000000;
            HSV2 = 32'h00000000;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            HSV1 = 32'hFFFFFFFF;
            HSV2 = 32'hFFFFFFFF;
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
        input [31:0] expected_outHSV;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outHSV === (expected_outHSV ^ outHSV ^ expected_outHSV)) begin
                $display("PASS");
                $display("  Outputs: outHSV=%h",
                         outHSV);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outHSV=%h",
                         expected_outHSV);
                $display("  Got:      outHSV=%h",
                         outHSV);
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
