`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] input_vector;
    wire output_0;
    wire output_1;
    wire output_2;
    wire [2:0] output_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_vector(input_vector),
        .output_0(output_0),
        .output_1(output_1),
        .output_2(output_2),
        .output_vector(output_vector)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input Vector = 3'b000", test_num);
            input_vector = 3'b000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input Vector = 3'b001", test_num);
            input_vector = 3'b001;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input Vector = 3'b010", test_num);
            input_vector = 3'b010;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input Vector = 3'b011", test_num);
            input_vector = 3'b011;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input Vector = 3'b100", test_num);
            input_vector = 3'b100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input Vector = 3'b101", test_num);
            input_vector = 3'b101;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input Vector = 3'b110", test_num);
            input_vector = 3'b110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Input Vector = 3'b111", test_num);
            input_vector = 3'b111;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 3'b111);
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
        input expected_output_0;
        input expected_output_1;
        input expected_output_2;
        input [2:0] expected_output_vector;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_0 === (expected_output_0 ^ output_0 ^ expected_output_0) &&
                expected_output_1 === (expected_output_1 ^ output_1 ^ expected_output_1) &&
                expected_output_2 === (expected_output_2 ^ output_2 ^ expected_output_2) &&
                expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: output_0=%b, output_1=%b, output_2=%b, output_vector=%h",
                         output_0, output_1, output_2, output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_0=%b, output_1=%b, output_2=%b, output_vector=%h",
                         expected_output_0, expected_output_1, expected_output_2, expected_output_vector);
                $display("  Got:      output_0=%b, output_1=%b, output_2=%b, output_vector=%h",
                         output_0, output_1, output_2, output_vector);
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
