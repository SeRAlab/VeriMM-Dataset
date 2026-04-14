`timescale 1ns/1ps

module chebyshev_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] freq_in;
    wire [4:0] freq_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chebyshev_filter dut (
        .freq_in(freq_in),
        .freq_out(freq_out)
    );
    task testcase001;

        begin
            test_num = 1;
            freq_in = 5'd0;
            $display("\nTestcase %0d: Input Zero Frequency", test_num);

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            freq_in = 5'd4;
            $display("\nTestcase %0d: Low Frequency (Stop-band)", test_num);

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            freq_in = 5'd8;
            $display("\nTestcase %0d: Mid-low Frequency", test_num);

            #1;


            check_outputs(5'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            freq_in = 5'd16;
            $display("\nTestcase %0d: Mid Frequency (Cutoff Region)", test_num);
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            freq_in = 5'd24;
            $display("\nTestcase %0d: High Frequency (Pass-band)", test_num);
            #1;

            check_outputs(5'd24);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            freq_in = 5'd31;
            $display("\nTestcase %0d: Maximum Frequency", test_num);

            #1;


            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            freq_in = 5'd28;
            $display("\nTestcase %0d: Pass-band Ripple Check A", test_num);
            #1;

            check_outputs(5'd27);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            freq_in = 5'd30;
            $display("\nTestcase %0d: Pass-band Ripple Check B", test_num);
            #1;

            check_outputs(5'd30);
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
        input [4:0] expected_freq_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_freq_out === (expected_freq_out ^ freq_out ^ expected_freq_out)) begin
                $display("PASS");
                $display("  Outputs: freq_out=%h",
                         freq_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq_out=%h",
                         expected_freq_out);
                $display("  Got:      freq_out=%h",
                         freq_out);
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
