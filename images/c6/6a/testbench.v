`timescale 1ns/1ps

module bitwise_and_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_a;
    reg [7:0] input_b;
    wire [7:0] output_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and dut (
        .input_a(input_a),
        .input_b(input_b),
        .output_result(output_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            input_a = 8'h00;
            input_b = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            input_a = 8'hFF;
            input_b = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bits (AA & 55)", test_num);
            input_a = 8'hAA;
            input_b = 8'h55;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Nibble Mask", test_num);
            input_a = 8'hF0;
            input_b = 8'hFF;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low Nibble Mask", test_num);
            input_a = 8'h0F;
            input_b = 8'hFF;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overlap 1 (12 & 34)", test_num);
            input_a = 8'h12;
            input_b = 8'h34;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overlap 2 (CC & AA)", test_num);
            input_a = 8'hCC;
            input_b = 8'hAA;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit overlap", test_num);
            input_a = 8'h01;
            input_b = 8'h01;
            #1;

            check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and Testbench");
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
        input [7:0] expected_output_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_result === (expected_output_result ^ output_result ^ expected_output_result)) begin
                $display("PASS");
                $display("  Outputs: output_result=%h",
                         output_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_result=%h",
                         expected_output_result);
                $display("  Got:      output_result=%h",
                         output_result);
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
