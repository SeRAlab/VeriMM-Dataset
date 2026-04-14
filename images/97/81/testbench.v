`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_data0;
    wire [31:0] o_data0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data0(i_data0),
        .o_data0(o_data0)
    );
    task testcase001;

        begin
            test_num = 1;
            i_data0 = 32'd0;
            #10;
            $display("Test Case %0d: i_data0 = %0d", test_num, i_data0);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            i_data0 = 32'd1;
            #10;
            $display("Test Case %0d: i_data0 = %0d", test_num, i_data0);
            #1;

            check_outputs(32'h000405C0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            i_data0 = 32'd100;
            #10;
            $display("Test Case %0d: i_data0 = %0d", test_num, i_data0);
            #1;

            check_outputs(32'h01923F00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            i_data0 = 32'hFFFFFFFF;
            #10;
            $display("Test Case %0d: i_data0 = -1", test_num);
            #1;

            check_outputs(32'hFFFBFA40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            i_data0 = 32'd16384;
            #10;
            $display("Test Case %0d: i_data0 = %0d", test_num, i_data0);
            #1;

            check_outputs(32'h016C8000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            i_data0 = 32'd255;
            #10;
            $display("Test Case %0d: i_data0 = %0d", test_num, i_data0);
            #1;

            check_outputs(32'h0401BA40);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            i_data0 = 32'hFFFFFC18;
            #10;
            $display("Test Case %0d: i_data0 = -1000", test_num);
            #1;

            check_outputs(32'hF0498A00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            i_data0 = 32'd12345678;
            #10;
            $display("Test Case %0d: i_data0 = %0d", test_num, i_data0);
            #1;

            check_outputs(32'hC11B7000);
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
        input [31:0] expected_o_data0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data0 === (expected_o_data0 ^ o_data0 ^ expected_o_data0)) begin
                $display("PASS");
                $display("  Outputs: o_data0=%h",
                         o_data0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data0=%h",
                         expected_o_data0);
                $display("  Got:      o_data0=%h",
                         o_data0);
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
