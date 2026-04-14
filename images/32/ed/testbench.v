`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in_signal;
    reg [15:0] ratio;
    reg [15:0] threshold;
    wire [15:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .in_signal(in_signal),
        .ratio(ratio),
        .threshold(threshold),
        .out_signal(out_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive input below threshold", test_num);
            in_signal = 16'd1000;
            threshold = 16'd2000;
            ratio = 16'd2;
            #10;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative input below threshold", test_num);
            in_signal = -16'd1000;
            threshold = 16'd2000;
            ratio = 16'd2;
            #10;
            #1;

            check_outputs(16'hFC18);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input exactly at threshold", test_num);
            in_signal = 16'd2000;
            threshold = 16'd2000;
            ratio = 16'd4;
            #10;
            #1;

            check_outputs(16'd2000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive input above threshold (2:1)", test_num);
            in_signal = 16'd3000;
            threshold = 16'd1000;
            ratio = 16'd2;
            #10;
            #1;

            check_outputs(16'd2000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative input above threshold (2:1)", test_num);
            in_signal = -16'd3000;
            threshold = 16'd1000;
            ratio = 16'd2;
            #10;
            #1;

            check_outputs(16'hF830);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High compression ratio (10:1)", test_num);
            in_signal = 16'd5000;
            threshold = 16'd1000;
            ratio = 16'd10;
            #10;
            #1;

            check_outputs(16'd1400);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 1:1 (No compression)", test_num);
            in_signal = 16'd10000;
            threshold = 16'd500;
            ratio = 16'd1;
            #10;
            #1;

            check_outputs(16'd10000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input", test_num);
            in_signal = 16'd0;
            threshold = 16'd500;
            ratio = 16'd4;
            #10;
            #1;

            check_outputs(16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        input [15:0] expected_out_signal;
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
