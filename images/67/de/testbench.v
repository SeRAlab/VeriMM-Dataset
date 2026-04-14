`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] and_a;
    reg [31:0] and_b;
    wire [31:0] result_and;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .and_a(and_a),
        .and_b(and_b),
        .result_and(result_and)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            and_a = 32'h00000000;
            and_b = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            and_a = 32'hFFFFFFFF;
            and_b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Patterns", test_num);
            and_a = 32'hAAAAAAAA;
            and_b = 32'h55555555;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Masking Upper 16 bits", test_num);
            and_a = 32'hFFFFFFFF;
            and_b = 32'h0000FFFF;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Masking Lower 16 bits", test_num);
            and_a = 32'hFFFFFFFF;
            and_b = 32'hFFFF0000;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Nibbles", test_num);
            and_a = 32'hF0F0F0F0;
            and_b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hF0F0F0F0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 0 Only", test_num);
            and_a = 32'h00000001;
            and_b = 32'h00000001;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 31 Only", test_num);
            and_a = 32'h80000000;
            and_b = 32'h80000000;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 1", test_num);
            and_a = 32'h12345678;
            and_b = 32'h87654321;



            #1;




            check_outputs(32'h02244220);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 2", test_num);
            and_a = 32'hA5A5A5A5;
            and_b = 32'hFFFF0000;
            #1;

            check_outputs(32'hA5A50000);
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
        input [31:0] expected_result_and;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_and === (expected_result_and ^ result_and ^ expected_result_and)) begin
                $display("PASS");
                $display("  Outputs: result_and=%h",
                         result_and);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_and=%h",
                         expected_result_and);
                $display("  Got:      result_and=%h",
                         result_and);
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
