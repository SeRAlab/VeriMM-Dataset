`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] input_data;
    wire [15:0] encrypted_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_data(input_data),
        .encrypted_output(encrypted_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input", test_num);
            input_data = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Inputs", test_num);
            input_data = 16'h0101;
            #1;

            check_outputs(16'h0406);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Max, Lower Zero", test_num);
            input_data = 16'hFF00;
            #1;

            check_outputs(16'hFDFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Zero, Lower Max", test_num);
            input_data = 16'h00FF;
            #1;

            check_outputs(16'hFFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Max", test_num);
            input_data = 16'hFFFF;
            #1;

            check_outputs(16'hFCFA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Hex (1234)", test_num);
            input_data = 16'h1234;
            #1;

            check_outputs(16'h6A16);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: AA55 Pattern", test_num);
            input_data = 16'hAA55;
            #1;

            check_outputs(16'h5353);
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
        input [15:0] expected_encrypted_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encrypted_output === (expected_encrypted_output ^ encrypted_output ^ expected_encrypted_output)) begin
                $display("PASS");
                $display("  Outputs: encrypted_output=%h",
                         encrypted_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_output=%h",
                         expected_encrypted_output);
                $display("  Got:      encrypted_output=%h",
                         encrypted_output);
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
