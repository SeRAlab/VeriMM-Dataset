`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_four;
    reg [31:0] input_one;
    reg [31:0] input_three;
    reg [1:0] selector;
    wire [31:0] output_final;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_four(input_four),
        .input_one(input_one),
        .input_three(input_three),
        .selector(selector),
        .output_final(output_final)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Selector 00 (Fixed Output 4)", test_num);
            input_one   = 32'hAAAA_AAAA;
            input_three = 32'hBBBB_BBBB;
            input_four  = 32'hCCCC_CCCC;
            selector    = 2'b00;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Selector 01 (Select input_one)", test_num);
            input_one   = 32'h1234_5678;
            input_three = 32'hBBBB_BBBB;
            input_four  = 32'hCCCC_CCCC;
            selector    = 2'b01;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Selector 10 (Select input_three)", test_num);
            input_one   = 32'hAAAA_AAAA;
            input_three = 32'hDEAD_BEEF;
            input_four  = 32'hCCCC_CCCC;
            selector    = 2'b10;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Selector 11 (Select input_four)", test_num);
            input_one   = 32'hAAAA_AAAA;
            input_three = 32'hBBBB_BBBB;
            input_four  = 32'hFEED_FACE;
            selector    = 2'b11;
            #1;

            check_outputs(32'hFEED_FACE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verifying selector 00 with different input values", test_num);
            input_one   = 32'hFFFF_FFFF;
            input_three = 32'h0000_0000;
            input_four  = 32'h5555_5555;
            selector    = 2'b00;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verifying all paths with zero inputs", test_num);
            input_one   = 32'h0;
            input_three = 32'h0;
            input_four  = 32'h0;

            selector = 2'b00; #1;
 check_outputs(32'h4);
            selector = 2'b01; #1;
 check_outputs(32'h0);
            selector = 2'b10; #1;
 check_outputs(32'h0);
            selector = 2'b11; #1;
 check_outputs(32'h0);
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
        input [31:0] expected_output_final;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_final === (expected_output_final ^ output_final ^ expected_output_final)) begin
                $display("PASS");
                $display("  Outputs: output_final=%h",
                         output_final);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_final=%h",
                         expected_output_final);
                $display("  Got:      output_final=%h",
                         output_final);
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
