`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg new_bit;
    reg [31:0] poly;
    reg [31:0] stage_input;
    wire [31:0] stage_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .new_bit(new_bit),
        .poly(poly),
        .stage_input(stage_input),
        .stage_output(stage_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All zeros input", test_num);
            stage_input = 32'h00000000;
            new_bit = 1'b0;
            poly = 32'h04C11DB7;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Feedback triggered by new_bit", test_num);
            stage_input = 32'h00000000;
            new_bit = 1'b1;
            poly = 32'h04C11DB7;

            #1;


            check_outputs(32'h04C11DB7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Feedback triggered by MSB", test_num);
            stage_input = 32'h80000000;
            new_bit = 1'b0;
            poly = 32'h04C11DB7;

            #1;


            check_outputs(32'h04C11DB7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: MSB and new_bit cancel out", test_num);
            stage_input = 32'h80000000;
            new_bit = 1'b1;
            poly = 32'h04C11DB7;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Left shift without feedback", test_num);
            stage_input = 32'h55555555;
            new_bit = 1'b0;
            poly = 32'h04C11DB7;

            #1;


            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Arbitrary shift and XOR", test_num);
            stage_input = 32'hAAAAAAAA;
            new_bit = 1'b0;
            poly = 32'h04C11DB7;


            #1;



            check_outputs(32'h519448E3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Alternative polynomial", test_num);
            stage_input = 32'h80000000;
            new_bit = 1'b0;
            poly = 32'h12345678;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: All bits high", test_num);
            stage_input = 32'hFFFFFFFF;
            new_bit = 1'b1;
            poly = 32'h04C11DB7;

            #1;


            check_outputs(32'hFFFFFFFE);
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
        input [31:0] expected_stage_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stage_output === (expected_stage_output ^ stage_output ^ expected_stage_output)) begin
                $display("PASS");
                $display("  Outputs: stage_output=%h",
                         stage_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stage_output=%h",
                         expected_stage_output);
                $display("  Got:      stage_output=%h",
                         stage_output);
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
