`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i_bus1;
    reg [7:0] i_bus2;
    wire [7:0] o_bus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_bus1(i_bus1),
        .i_bus2(i_bus2),
        .o_bus(o_bus)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            i_bus1 = 8'h00;
            i_bus2 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            i_bus1 = 8'hFF;
            i_bus2 = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed inputs (FF & 00)", test_num);
            i_bus1 = 8'hFF;
            i_bus2 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (AA & 55)", test_num);
            i_bus1 = 8'hAA;
            i_bus2 = 8'h55;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Patterns (AA & AA)", test_num);
            i_bus1 = 8'hAA;
            i_bus2 = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Nibble selection (F0 & CC)", test_num);
            i_bus1 = 8'hF0;
            i_bus2 = 8'hCC;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit overlap (80 & 81)", test_num);
            i_bus1 = 8'h80;
            i_bus2 = 8'h81;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex patterns (5A & 3C)", test_num);
            i_bus1 = 8'h5A;
            i_bus2 = 8'h3C;
            #1;

            check_outputs(8'h18);
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
        input [7:0] expected_o_bus;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_bus === (expected_o_bus ^ o_bus ^ expected_o_bus)) begin
                $display("PASS");
                $display("  Outputs: o_bus=%h",
                         o_bus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_bus=%h",
                         expected_o_bus);
                $display("  Got:      o_bus=%h",
                         o_bus);
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
