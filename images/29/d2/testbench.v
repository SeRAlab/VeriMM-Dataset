`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] compression_ratio;
    reg [9:0] input_signal;
    reg [9:0] threshold;
    wire [9:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .compression_ratio(compression_ratio),
        .input_signal(input_signal),
        .threshold(threshold),
        .output_signal(output_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input below threshold", test_num);
            input_signal = 10'd100;
            threshold = 10'd200;
            compression_ratio = 10'd2;

            #1;


            check_outputs(10'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input equal to threshold", test_num);
            input_signal = 10'd250;
            threshold = 10'd250;
            compression_ratio = 10'd4;

            #1;


            check_outputs(10'd250);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input above threshold (even division)", test_num);
            input_signal = 10'd500;
            threshold = 10'd100;
            compression_ratio = 10'd2;

            #1;


            check_outputs(10'd300);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input above threshold (integer division floor)", test_num);
            input_signal = 10'd301;
            threshold = 10'd100;
            compression_ratio = 10'd2;

            #1;


            check_outputs(10'd200);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio is 1", test_num);
            input_signal = 10'd800;
            threshold = 10'd200;
            compression_ratio = 10'd1;

            #1;


            check_outputs(10'd800);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Threshold is 0", test_num);
            input_signal = 10'd1000;
            threshold = 10'd0;
            compression_ratio = 10'd10;

            #1;


            check_outputs(10'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High compression at max input", test_num);
            input_signal = 10'd1023;
            threshold = 10'd512;
            compression_ratio = 10'd511;

            #1;


            check_outputs(10'd513);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio larger than delta", test_num);
            input_signal = 10'd550;
            threshold = 10'd500;
            compression_ratio = 10'd100;

            #1;


            check_outputs(10'd500);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input, max threshold", test_num);
            input_signal = 10'd0;
            threshold = 10'd1023;
            compression_ratio = 10'd2;

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small delta above threshold", test_num);
            input_signal = 10'd10;
            threshold = 10'd5;
            compression_ratio = 10'd2;

            #1;


            check_outputs(10'd7);
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
        input [9:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
