`timescale 1ns/1ps

module split_bytes_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_signal;
    wire [3:0] output_signal_1;
    wire [3:0] output_signal_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    split_bytes dut (
        .input_signal(input_signal),
        .output_signal_1(output_signal_1),
        .output_signal_2(output_signal_2)
    );
    task testcase001;

        begin
            $display("Test Case 001: All zeros");
            input_signal = 8'h00;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All ones");
            input_signal = 8'hFF;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Alternating pattern A5");
            input_signal = 8'hA5;
            #1;

            check_outputs(4'hA, 4'h5);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Alternating pattern 5A");
            input_signal = 8'h5A;
            #1;

            check_outputs(4'h5, 4'hA);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: MSB nibble full, LSB nibble empty");
            input_signal = 8'hF0;
            #1;

            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: MSB nibble empty, LSB nibble full");
            input_signal = 8'h0F;
            #1;

            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Sequential pattern 12");
            input_signal = 8'h12;
            #1;

            check_outputs(4'h1, 4'h2);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Complex pattern DE");
            input_signal = 8'hDE;
            #1;

            check_outputs(4'hD, 4'hE);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Pattern 7B");
            input_signal = 8'h7B;
            #1;

            check_outputs(4'h7, 4'hB);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Pattern 3C");
            input_signal = 8'h3C;
            #1;

            check_outputs(4'h3, 4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("split_bytes Testbench");
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
        input [3:0] expected_output_signal_1;
        input [3:0] expected_output_signal_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal_1 === (expected_output_signal_1 ^ output_signal_1 ^ expected_output_signal_1) &&
                expected_output_signal_2 === (expected_output_signal_2 ^ output_signal_2 ^ expected_output_signal_2)) begin
                $display("PASS");
                $display("  Outputs: output_signal_1=%h, output_signal_2=%h",
                         output_signal_1, output_signal_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal_1=%h, output_signal_2=%h",
                         expected_output_signal_1, expected_output_signal_2);
                $display("  Got:      output_signal_1=%h, output_signal_2=%h",
                         output_signal_1, output_signal_2);
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
