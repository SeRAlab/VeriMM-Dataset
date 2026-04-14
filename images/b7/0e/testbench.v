`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] cor_x;
    reg [9:0] cor_y;
    wire [8:0] ind_i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cor_x(cor_x),
        .cor_y(cor_y),
        .ind_i(ind_i)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            cor_x = 10'd240;
            cor_y = 10'd0;

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            cor_x = 10'd255;
            cor_y = 10'd15;

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            cor_x = 10'd256;
            cor_y = 10'd0;

            #1;


            check_outputs(9'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            cor_x = 10'd240;
            cor_y = 10'd16;

            #1;


            check_outputs(9'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            cor_x = 10'd320;
            cor_y = 10'd48;

            #1;


            check_outputs(9'd35);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            cor_x = 10'd384;
            cor_y = 10'd160;

            #1;


            check_outputs(9'd109);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            cor_x = 10'd271;
            cor_y = 10'd31;

            #1;


            check_outputs(9'd11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            cor_x = 10'd384;
            cor_y = 10'd0;

            #1;


            check_outputs(9'd9);
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
        input [8:0] expected_ind_i;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ind_i === (expected_ind_i ^ ind_i ^ expected_ind_i)) begin
                $display("PASS");
                $display("  Outputs: ind_i=%h",
                         ind_i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ind_i=%h",
                         expected_ind_i);
                $display("  Got:      ind_i=%h",
                         ind_i);
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
