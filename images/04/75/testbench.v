`timescale 1ns/1ps

module dwt_haar_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] signal_in;
    wire [3:0] coeff_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_haar dut (
        .signal_in(signal_in),
        .coeff_out(coeff_out)
    );
    task testcase001;

        begin
            test_num = 1;
            signal_in = 4'b0000;
            $display("\nTestcase %0d: All Zeros", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            signal_in = 4'b1111;
            $display("\nTestcase %0d: Constant DC Signal", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            signal_in = 4'b1100;
            $display("\nTestcase %0d: Step Signal (1100)", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            signal_in = 4'b0011;
            $display("\nTestcase %0d: Step Signal (0011)", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            signal_in = 4'b1010;
            $display("\nTestcase %0d: High Frequency Alternating (1010)", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            signal_in = 4'b1000;
            $display("\nTestcase %0d: Impulse at x3 (1000)", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            signal_in = 4'b0001;
            $display("\nTestcase %0d: Impulse at x0 (0001)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            signal_in = 4'b1110;
            $display("\nTestcase %0d: Complex Signal (1110)", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_haar Testbench");
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
        input [3:0] expected_coeff_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_coeff_out === (expected_coeff_out ^ coeff_out ^ expected_coeff_out)) begin
                $display("PASS");
                $display("  Outputs: coeff_out=%h",
                         coeff_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: coeff_out=%h",
                         expected_coeff_out);
                $display("  Got:      coeff_out=%h",
                         coeff_out);
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
