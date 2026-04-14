`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_signal;
    reg [7:0] threshold;
    wire [7:0] out_signal;

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
            test_num = 1;
            $display("Test %0d: Input below threshold (no compression)", test_num);
            in_signal = 8'd50;
            threshold = 8'd100;

            #1;


            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Input exactly at threshold", test_num);
            in_signal = 8'd120;
            threshold = 8'd120;

            #1;


            check_outputs(8'd120);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Input above threshold (even difference)", test_num);
            in_signal = 8'd150;
            threshold = 8'd100;

            #1;


            check_outputs(8'd125);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Input above threshold (odd difference, floor check)", test_num);
            in_signal = 8'd101;
            threshold = 8'd100;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Maximum input with mid-range threshold", test_num);
            in_signal = 8'd255;
            threshold = 8'd127;

            #1;


            check_outputs(8'd191);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Input with zero threshold (full compression range)", test_num);
            in_signal = 8'd200;
            threshold = 8'd0;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Zero input", test_num);
            in_signal = 8'd0;
            threshold = 8'd50;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Threshold at maximum (no compression possible)", test_num);
            in_signal = 8'd250;
            threshold = 8'd255;

            #1;


            check_outputs(8'd250);
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
        input [7:0] expected_out_signal;
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
