`timescale 1ns/1ps

module twos_complement_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] binary_input;
    wire [4:0] twos_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    twos_complement dut (
        .binary_input(binary_input),
        .twos_output(twos_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 00000 (Zero)", test_num);
            binary_input = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 00001 (Positive One)", test_num);
            binary_input = 5'b00001;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 11111 (Negative One)", test_num);
            binary_input = 5'b11111;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 01111 (Max Positive 15)", test_num);
            binary_input = 5'b01111;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 10001 (Negative 15)", test_num);
            binary_input = 5'b10001;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 10000 (Min Negative -16)", test_num);
            binary_input = 5'b10000;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 01010 (Decimal 10)", test_num);
            binary_input = 5'b01010;
            #1;

            check_outputs(5'b10110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 10110 (Decimal -10)", test_num);
            binary_input = 5'b10110;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("twos_complement Testbench");
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
        input [4:0] expected_twos_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_twos_output === (expected_twos_output ^ twos_output ^ expected_twos_output)) begin
                $display("PASS");
                $display("  Outputs: twos_output=%h",
                         twos_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: twos_output=%h",
                         expected_twos_output);
                $display("  Got:      twos_output=%h",
                         twos_output);
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
