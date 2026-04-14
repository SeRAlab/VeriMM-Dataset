`timescale 1ns/1ps

module comparator_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire A_equals_B;
    wire A_greater_B;
    wire A_less_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_16bit dut (
        .A(A),
        .B(B),
        .A_equals_B(A_equals_B),
        .A_greater_B(A_greater_B),
        .A_less_B(A_less_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Equality at zero", test_num);
            A = 16'h0000;
            B = 16'h0000;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Equality at maximum value", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A is greater than B (extreme difference)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A is less than B (extreme difference)", test_num);
            A = 16'h0000;
            B = 16'hFFFF;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A is greater than B (MSB difference)", test_num);
            A = 16'h8000;
            B = 16'h7FFF;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A is less than B (MSB difference)", test_num);
            A = 16'h7FFF;
            B = 16'h8000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A is greater than B (LSB difference)", test_num);
            A = 16'h0001;
            B = 16'h0000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: A is less than B (LSB difference)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Random equality", test_num);
            A = 16'hA5A5;
            B = 16'hA5A5;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Mid-range comparison", test_num);
            A = 16'h1234;
            B = 16'h5678;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_16bit Testbench");
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
        input expected_A_equals_B;
        input expected_A_greater_B;
        input expected_A_less_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_equals_B === (expected_A_equals_B ^ A_equals_B ^ expected_A_equals_B) &&
                expected_A_greater_B === (expected_A_greater_B ^ A_greater_B ^ expected_A_greater_B) &&
                expected_A_less_B === (expected_A_less_B ^ A_less_B ^ expected_A_less_B)) begin
                $display("PASS");
                $display("  Outputs: A_equals_B=%b, A_greater_B=%b, A_less_B=%b",
                         A_equals_B, A_greater_B, A_less_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_equals_B=%b, A_greater_B=%b, A_less_B=%b",
                         expected_A_equals_B, expected_A_greater_B, expected_A_less_B);
                $display("  Got:      A_equals_B=%b, A_greater_B=%b, A_less_B=%b",
                         A_equals_B, A_greater_B, A_less_B);
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
