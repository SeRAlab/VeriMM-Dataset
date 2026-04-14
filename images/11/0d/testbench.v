`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] signal_in;
    wire zero_cross;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .signal_in(signal_in),
        .zero_cross(zero_cross)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative to Positive Transition (-10 to 10)", test_num);
            reset_dut();
            signal_in = -8'd10;
            @(posedge clk);
            signal_in = 8'd10;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative to Zero Transition (-5 to 0)", test_num);
            reset_dut();
            signal_in = -8'd5;
            @(posedge clk);
            signal_in = 8'd0;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Positive to Negative Transition (10 to -10)", test_num);
            reset_dut();
            signal_in = 8'd10;
            @(posedge clk);
            signal_in = -8'd10;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero to Positive Transition (0 to 5)", test_num);
            reset_dut();
            signal_in = 8'd0;
            @(posedge clk);
            signal_in = 8'd5;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative to Negative Transition (-10 to -2)", test_num);
            reset_dut();
            signal_in = -8'd10;
            @(posedge clk);
            signal_in = -8'd2;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Extreme Negative to Extreme Positive (-128 to 127)", test_num);
            reset_dut();
            signal_in = -8'd128;
            @(posedge clk);
            signal_in = 8'd127;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-step transition (-5 -> 0 -> 5)", test_num);
            reset_dut();
            signal_in = -8'd5;
            @(posedge clk);
            signal_in = 8'd0;
            @(posedge clk);
            signal_in = 8'd5;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Positive to Zero Transition (10 to 0)", test_num);
            reset_dut();
            signal_in = 8'd10;
            @(posedge clk);
            signal_in = 8'd0;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zero_crossing_detector Testbench");
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
        input expected_zero_cross;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zero_cross === (expected_zero_cross ^ zero_cross ^ expected_zero_cross)) begin
                $display("PASS");
                $display("  Outputs: zero_cross=%b",
                         zero_cross);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero_cross=%b",
                         expected_zero_cross);
                $display("  Got:      zero_cross=%b",
                         zero_cross);
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
