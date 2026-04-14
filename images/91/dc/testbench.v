`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [7:0] num1;
    reg [7:0] num2;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .num1(num1),
        .num2(num2),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            num1 = 8'sd12;
            num2 = 8'sd15;
            ctrl = 2'b00;
            #1;

            check_outputs(8'sd27);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            num1 = -8'sd10;
            num2 = -8'sd20;
            ctrl = 2'b00;
            #1;

            check_outputs(-8'sd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            num1 = 8'sd40;
            num2 = 8'sd15;
            ctrl = 2'b01;
            #1;

            check_outputs(8'sd25);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            num1 = 8'sd10;
            num2 = 8'sd25;
            ctrl = 2'b01;
            #1;

            check_outputs(-8'sd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            num1 = 8'sd6;
            num2 = 8'sd4;
            ctrl = 2'b10;
            #1;

            check_outputs(8'sd24);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            num1 = -8'sd5;
            num2 = 8'sd3;
            ctrl = 2'b10;
            #1;

            check_outputs(-8'sd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            num1 = 8'sd80;
            num2 = 8'sd4;
            ctrl = 2'b11;
            #1;

            check_outputs(8'sd20);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            num1 = -8'sd100;
            num2 = 8'sd10;
            ctrl = 2'b11;
            #1;

            check_outputs(-8'sd10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            num1 = 8'sd0;
            num2 = 8'sd0;
            ctrl = 2'b00;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            num1 = 8'sd25;
            num2 = 8'sd0;
            ctrl = 2'b10;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            num1 = 8'sd55;
            num2 = 8'sd55;
            ctrl = 2'b01;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            num1 = 8'sd0;
            num2 = 8'sd15;
            ctrl = 2'b11;
            #1;

            check_outputs(8'sd0);
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_result;
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
