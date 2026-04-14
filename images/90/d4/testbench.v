`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] I;
    wire [1:0] encoded_value;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .encoded_value(encoded_value),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs low", test_num);
            I = 4'b0000;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only I[0] high", test_num);
            I = 4'b0001;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only I[1] high", test_num);
            I = 4'b0010;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only I[2] high", test_num);
            I = 4'b0100;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only I[3] high", test_num);
            I = 4'b1000;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority check - I[3] and I[0] active", test_num);
            I = 4'b1001;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority check - I[2], I[1], and I[0] active", test_num);
            I = 4'b0111;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority check - I[1] and I[0] active", test_num);
            I = 4'b0011;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority check - All inputs active", test_num);
            I = 4'b1111;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority check - I[3] and I[2] active", test_num);
            I = 4'b1100;
            #1;

            check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_encoded_value;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_value === (expected_encoded_value ^ encoded_value ^ expected_encoded_value) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_value=%h, valid=%b",
                         encoded_value, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_value=%h, valid=%b",
                         expected_encoded_value, expected_valid);
                $display("  Got:      encoded_value=%h, valid=%b",
                         encoded_value, valid);
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
