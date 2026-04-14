`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] leftOperand;
    reg [31:0] rightOperand;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .leftOperand(leftOperand),
        .rightOperand(rightOperand),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            leftOperand = 32'd0;
            rightOperand = 32'd12345;
            $display("Testcase %0d: Multiply by Zero", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            leftOperand = 32'd1;
            rightOperand = 32'd54321;
            $display("Testcase %0d: Multiply by One", test_num);
            #1;

            check_outputs(32'd54321);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            leftOperand = 32'd10;
            rightOperand = 32'd20;
            $display("Testcase %0d: Small numbers (10 * 20)", test_num);
            #1;

            check_outputs(32'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            leftOperand = 32'hFFFFFFFF;
            rightOperand = 32'd5;
            $display("Testcase %0d: Multi-bit truncation (0xFFFFFFFF * 5)", test_num);

            #1;


            check_outputs(32'hFFFFFFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            leftOperand = 32'h00010000;
            rightOperand = 32'h00010000;
            $display("Testcase %0d: Power of 2 Overflow (2^16 * 2^16 = 2^32)", test_num);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            leftOperand = 32'hABCDE;
            rightOperand = 32'h12345;
            $display("Testcase %0d: Large arbitrary values (0xABCDE * 0x12345)", test_num);

            #1;


            check_outputs(32'h34E05B76);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            leftOperand = 32'hFFFFFFFF;
            rightOperand = 32'hFFFFFFFF;
            $display("Testcase %0d: Max values (-1 * -1)", test_num);

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            leftOperand = 32'd12345678;
            rightOperand = 32'd87654321;
            $display("Testcase %0d: Large decimal values", test_num);


            #1;



            check_outputs(32'h439E6D7E);
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
        input [31:0] expected_result;
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
