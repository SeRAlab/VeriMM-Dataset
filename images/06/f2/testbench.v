`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] noisy_signal;
    wire [4:0] clean_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .noisy_signal(noisy_signal),
        .clean_signal(clean_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All bits zero", test_num);
            noisy_signal = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit set (bit 0)", test_num);
            noisy_signal = 5'b00001;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit set (bit 2)", test_num);
            noisy_signal = 5'b00100;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Two bits set (bit 0 and 1)", test_num);
            noisy_signal = 5'b00011;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Two bits set (bit 0 and 2) with upper bits high", test_num);
            noisy_signal = 5'b11101;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All three last bits set", test_num);
            noisy_signal = 5'b00111;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All five bits set", test_num);
            noisy_signal = 5'b11111;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Upper bits high, last three bits zero", test_num);
            noisy_signal = 5'b11000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating bits (10101)", test_num);
            noisy_signal = 5'b10101;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bits 0 and 1 set", test_num);
            noisy_signal = 5'b01011;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression Testbench");
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
        input [4:0] expected_clean_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clean_signal === (expected_clean_signal ^ clean_signal ^ expected_clean_signal)) begin
                $display("PASS");
                $display("  Outputs: clean_signal=%h",
                         clean_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_signal=%h",
                         expected_clean_signal);
                $display("  Got:      clean_signal=%h",
                         clean_signal);
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
