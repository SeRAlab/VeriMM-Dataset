`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    wire carry;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .carry(carry),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Input zero (0x00)", test_num);
            x = 8'h00;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Input 1 (0x01)", test_num);
            x = 8'h01;
            #1;

            check_outputs(1'b0, 8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Max value without carry (0x7F)", test_num);
            x = 8'h7F;
            #1;

            check_outputs(1'b0, 8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Min value with carry (0x80)", test_num);
            x = 8'h80;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Max value (0xFF)", test_num);
            x = 8'hFF;
            #1;

            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Pattern 0x55", test_num);
            x = 8'h55;
            #1;

            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Pattern 0xAA", test_num);
            x = 8'hAA;
            #1;

            check_outputs(1'b1, 8'h54);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Arbitrary value 0x12", test_num);
            x = 8'h12;
            #1;

            check_outputs(1'b0, 8'h24);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Arbitrary value with carry 0xC3", test_num);
            x = 8'hC3;
            #1;

            check_outputs(1'b1, 8'h86);
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
        input expected_carry;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, result=%h",
                         carry, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, result=%h",
                         expected_carry, expected_result);
                $display("  Got:      carry=%b, result=%h",
                         carry, result);
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
