`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] analog_input;
    wire [2:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit dut (
        .analog_input(analog_input),
        .digital_output(digital_output)
    );
    task testcase001;

        begin
            test_num = 1;
            analog_input = 8'd0;
            $display("Test %0d: Input 0 (Segment 0 boundary)", test_num);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            analog_input = 8'd31;
            $display("Test %0d: Input 31 (Segment 0 boundary)", test_num);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            analog_input = 8'd32;
            $display("Test %0d: Input 32 (Segment 1 boundary)", test_num);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            analog_input = 8'd80;
            $display("Test %0d: Input 80 (Segment 2)", test_num);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            analog_input = 8'd127;
            $display("Test %0d: Input 127 (Segment 3 boundary)", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            analog_input = 8'd128;
            $display("Test %0d: Input 128 (Segment 4 boundary)", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            analog_input = 8'd175;
            $display("Test %0d: Input 175 (Segment 5)", test_num);
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            analog_input = 8'd223;
            $display("Test %0d: Input 223 (Segment 6 boundary)", test_num);
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            analog_input = 8'd224;
            $display("Test %0d: Input 224 (Segment 7 boundary)", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            analog_input = 8'd255;
            $display("Test %0d: Input 255 (Segment 7 boundary)", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8bit Testbench");
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
        input [2:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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
