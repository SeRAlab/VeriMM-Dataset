`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg add_sub;
    reg [35:0] dataa;
    reg [35:0] datab;
    wire [35:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_sub(add_sub),
        .dataa(dataa),
        .datab(datab),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Simple Addition (5 + 10)", test_num);
            dataa = 36'h000000005;
            datab = 36'h00000000A;
            add_sub = 1'b0;
            #1;

            check_outputs(36'h00000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simple Subcampaign (20 - 10)", test_num);
            dataa = 36'h000000014;
            datab = 36'h00000000A;
            add_sub = 1'b1;
            #1;

            check_outputs(36'h00000000A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Addition with maximum values (Overflow wrap)", test_num);
            dataa = 36'hFFFFFFFFF;
            datab = 36'h000000001;
            add_sub = 1'b0;
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction leading to negative result (0 - 1)", test_num);
            dataa = 36'h000000000;
            datab = 36'h000000001;
            add_sub = 1'b1;
            #1;

            check_outputs(36'hFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Adding zero", test_num);
            dataa = 36'hABCDE1234;
            datab = 36'h000000000;
            add_sub = 1'b0;
            #1;

            check_outputs(36'hABCDE1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Subtracting a value from itself", test_num);
            dataa = 36'h555555555;
            datab = 36'h555555555;
            add_sub = 1'b1;
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise patterns addition", test_num);
            dataa = 36'h555555555;
            datab = 36'hAAAAAAAAA;
            add_sub = 1'b0;
            #1;

            check_outputs(36'hFFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Large value subtraction", test_num);
            dataa = 36'hFFFFFFFFF;
            datab = 36'hAAAAAAAAA;
            add_sub = 1'b1;
            #1;

            check_outputs(36'h555555555);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Subtraction with zero", test_num);
            dataa = 36'h000000000;
            datab = 36'h000000000;
            add_sub = 1'b1;
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Addition near threshold", test_num);
            dataa = 36'h7FFFFFFFF;
            datab = 36'h000000001;
            add_sub = 1'b0;
            #1;

            check_outputs(36'h800000000);
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
        input [35:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
