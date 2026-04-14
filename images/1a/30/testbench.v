`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] signal_a;
    reg [15:0] signal_b;
    wire greater;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .signal_a(signal_a),
        .signal_b(signal_b),
        .greater(greater)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Equal values (0 vs 0)", test_num);
            signal_a = 16'd0;
            signal_b = 16'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: a > b (Small values)", test_num);
            signal_a = 16'd10;
            signal_b = 16'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: a < b (Small values)", test_num);
            signal_a = 16'd5;
            signal_b = 16'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Equal values (Max values)", test_num);
            signal_a = 16'hFFFF;
            signal_b = 16'hFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: a > b (Max vs Min)", test_num);
            signal_a = 16'hFFFF;
            signal_b = 16'h0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: a < b (Min vs Max)", test_num);
            signal_a = 16'h0000;
            signal_b = 16'hFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: a > b (Close values at high range)", test_num);
            signal_a = 16'hFFFE;
            signal_b = 16'hFFFD;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: a < b (Close values at high range)", test_num);
            signal_a = 16'hFFFD;
            signal_b = 16'hFFFE;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Midpoint comparison (Greater)", test_num);
            signal_a = 16'h8000;
            signal_b = 16'h7FFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Alternate bit patterns", test_num);
            signal_a = 16'hAAAA;
            signal_b = 16'h5555;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_comparator Testbench");
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
        input expected_greater;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater === (expected_greater ^ greater ^ expected_greater)) begin
                $display("PASS");
                $display("  Outputs: greater=%b",
                         greater);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater=%b",
                         expected_greater);
                $display("  Got:      greater=%b",
                         greater);
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
