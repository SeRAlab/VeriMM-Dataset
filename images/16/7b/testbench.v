`timescale 1ns/1ps

module adc_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] analog_input;
    wire [3:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_16bit dut (
        .analog_input(analog_input),
        .digital_output(digital_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 0 Minimum (0)", test_num);
            analog_input = 16'h0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 0 Upper Boundary (4095)", test_num);
            analog_input = 16'd4095;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 1 Lower Boundary (4096)", test_num);
            analog_input = 16'd4096;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 7 Upper Boundary (32767)", test_num);
            analog_input = 16'd32767;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 8 Lower Boundary (32768)", test_num);
            analog_input = 16'd32768;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 4 Intermediate Value (18000)", test_num);
            analog_input = 16'd18000;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 14 Upper Boundary (61439)", test_num);
            analog_input = 16'd61439;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 15 Lower Boundary (61440)", test_num);
            analog_input = 16'd61440;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Input (65535)", test_num);
            analog_input = 16'hFFFF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Level 12 Intermediate Value (50000)", test_num);
            analog_input = 16'd50000;
            #1;

            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_16bit Testbench");
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
        input [3:0] expected_digital_output;
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
