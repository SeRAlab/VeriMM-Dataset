`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] index;
    reg [2:0] state;
    reg [11:0] value;
    wire [31:0] temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .index(index),
        .state(state),
        .value(value),
        .temp(temp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: State = 1", test_num);
            state = 3'd1;
            value = 12'hABC;
            index = 5'd0;
            #1;

            check_outputs(32'h08000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: State = 2", test_num);
            state = 3'd2;
            value = 12'h123;
            index = 5'd10;
            #1;

            check_outputs(32'h08000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: State = 0", test_num);
            state = 3'd0;
            value = 12'hA5A;
            index = 5'd5;

            #1;


            check_outputs(32'h03FA5A00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: State = 3, Max Value", test_num);
            state = 3'd3;
            value = 12'hFFF;
            index = 5'd31;

            #1;


            check_outputs(32'h03FFFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: State = 7, Min Value", test_num);
            state = 3'd7;
            value = 12'h000;
            index = 5'd15;

            #1;


            check_outputs(32'h03F00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: State = 4, Mid Value", test_num);
            state = 3'd4;
            value = 12'h765;
            index = 5'd2;

            #1;


            check_outputs(32'h03F76500);
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
        input [31:0] expected_temp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temp === (expected_temp ^ temp ^ expected_temp)) begin
                $display("PASS");
                $display("  Outputs: temp=%h",
                         temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp=%h",
                         expected_temp);
                $display("  Got:      temp=%h",
                         temp);
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
