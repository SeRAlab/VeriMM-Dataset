`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] RD_PNTR_WR;
    reg [11:0] out;
    wire comp2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RD_PNTR_WR(RD_PNTR_WR),
        .out(out),
        .comp2(comp2)
    );
    task testcase001;

        begin
            test_num = 1;
            RD_PNTR_WR = 12'h000;
            out = 12'h000;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            RD_PNTR_WR = 12'h000;
            out = 12'h008;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            RD_PNTR_WR = 12'h000;
            out = 12'h004;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            RD_PNTR_WR = 12'h000;
            out = 12'h00C;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            RD_PNTR_WR = 12'h008;
            out = 12'h000;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            RD_PNTR_WR = 12'h008;
            out = 12'h008;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            RD_PNTR_WR = 12'h004;
            out = 12'h008;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            RD_PNTR_WR = 12'hFFF;
            out = 12'hFF3;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            RD_PNTR_WR = 12'hABC;
            out = 12'hAB4;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            RD_PNTR_WR = 12'h555;
            out = 12'hAAA;



            #1;




            check_outputs(1'b0);
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
        input expected_comp2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comp2 === (expected_comp2 ^ comp2 ^ expected_comp2)) begin
                $display("PASS");
                $display("  Outputs: comp2=%b",
                         comp2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp2=%b",
                         expected_comp2);
                $display("  Got:      comp2=%b",
                         comp2);
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
