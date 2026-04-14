`timescale 1ns/1ps

module quantizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in;
    wire [1:0] quantized_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quantizer dut (
        .pixel_in(pixel_in),
        .quantized_out(quantized_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Testing lower boundary of Level 0 (pixel_in = 0)", test_num);
            pixel_in = 8'd0;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Testing upper boundary of Level 0 (pixel_in = 63)", test_num);
            pixel_in = 8'd63;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Testing lower boundary of Level 1 (pixel_in = 64)", test_num);
            pixel_in = 8'd64;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Testing upper boundary of Level 1 (pixel_in = 127)", test_num);
            pixel_in = 8'd127;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Testing lower boundary of Level 2 (pixel_in = 128)", test_num);
            pixel_in = 8'd128;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Testing upper boundary of Level 2 (pixel_in = 191)", test_num);
            pixel_in = 8'd191;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Testing lower boundary of Level 3 (pixel_in = 192)", test_num);
            pixel_in = 8'd192;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Testing upper boundary of Level 3 (pixel_in = 255)", test_num);
            pixel_in = 8'd255;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Testing mid-range value (pixel_in = 100)", test_num);
            pixel_in = 8'd100;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Testing mid-range value (pixel_in = 200)", test_num);
            pixel_in = 8'd200;
            #1;

            check_outputs(2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quantizer Testbench");
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
        input [1:0] expected_quantized_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quantized_out === (expected_quantized_out ^ quantized_out ^ expected_quantized_out)) begin
                $display("PASS");
                $display("  Outputs: quantized_out=%h",
                         quantized_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quantized_out=%h",
                         expected_quantized_out);
                $display("  Got:      quantized_out=%h",
                         quantized_out);
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
