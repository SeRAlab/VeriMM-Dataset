`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_signal;
    reg [3:0] threshold;
    wire [3:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .in_signal(in_signal),
        .threshold(threshold),
        .out_signal(out_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Signal below threshold (No Compression)", test_num);
            in_signal = 4'd4;
            threshold = 4'd10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Signal equal to threshold (No Compression)", test_num);
            in_signal = 4'd8;
            threshold = 4'd8;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Signal above threshold (Even difference, 2:1 ratio)", test_num);
            in_signal = 4'd14;
            threshold = 4'd10;

            #1;


            check_outputs(4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Signal above threshold (Odd difference, rounding down)", test_num);
            in_signal = 4'd11;
            threshold = 4'd8;

            #1;


            check_outputs(4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Maximum input, low threshold", test_num);
            in_signal = 4'd15;
            threshold = 4'd5;

            #1;


            check_outputs(4'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Threshold at zero (Full range compression)", test_num);
            in_signal = 4'd14;
            threshold = 4'd0;

            #1;


            check_outputs(4'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input at zero", test_num);
            in_signal = 4'd0;
            threshold = 4'd5;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Threshold at maximum", test_num);
            in_signal = 4'd15;
            threshold = 4'd15;
            #1;

            check_outputs(4'd15);
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
