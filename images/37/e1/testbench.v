`timescale 1ns/1ps

module chebyshev_filter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_signal;
    wire [3:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chebyshev_filter dut (
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Minimum input (0)");
            in_signal = 4'd0;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Maximum input (15)");
            in_signal = 4'd15;

            #1;


            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Mid-range input (8)");
            in_signal = 4'd8;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Lower quadrant input (4)");
            in_signal = 4'd4;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Upper quadrant input (12)");
            in_signal = 4'd12;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Small step (1)");
            in_signal = 4'd1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: High value step (14)");
            in_signal = 4'd14;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Alternating bits (1010)");
            in_signal = 4'b1010;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Alternating bits (0101)");
            in_signal = 4'b0101;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Transition to 7");
            in_signal = 4'd7;
            #1;

            check_outputs(4'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chebyshev_filter Testbench");
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
        input [3:0] expected_out_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
