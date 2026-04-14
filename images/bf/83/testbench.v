`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg enable;
    reg rs;
    wire [2:0] ctrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .enable(enable),
        .rs(rs),
        .ctrl(ctrl)
    );
    task testcase001;

        begin
            test_num = 1;
            data = 8'h00;
            enable = 0;
            rs = 0;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 8'h00;
            enable = 1;
            rs = 1;

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 8'h00;
            enable = 1;
            rs = 0;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 8'h01;
            enable = 1;
            rs = 1;

            #1;


            check_outputs(3'b101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 8'h01;
            enable = 1;
            rs = 0;

            #1;


            check_outputs(3'b110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 8'hFF;
            enable = 0;
            rs = 1;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = 8'hFE;
            enable = 1;
            rs = 1;

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data = 8'h01;
            enable = 0;
            rs = 0;

            #1;


            check_outputs(3'b000);
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
        input [2:0] expected_ctrl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ctrl === (expected_ctrl ^ ctrl ^ expected_ctrl)) begin
                $display("PASS");
                $display("  Outputs: ctrl=%h",
                         ctrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ctrl=%h",
                         expected_ctrl);
                $display("  Got:      ctrl=%h",
                         ctrl);
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
