`timescale 1ns/1ps

module adc_8_to_4_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] voltage_in;
    wire [3:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8_to_4 dut (
        .voltage_in(voltage_in),
        .voltage_out(voltage_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Minimum Input (0)", test_num);
            voltage_in = 8'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Boundary Input (15)", test_num);
            voltage_in = 8'd15;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Lower Boundary Input (16)", test_num);
            voltage_in = 8'd16;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Upper Boundary Input (31)", test_num);
            voltage_in = 8'd31;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Midpoint Transition (127)", test_num);
            voltage_in = 8'd127;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Midpoint Transition (128)", test_num);
            voltage_in = 8'd128;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: High Range Input (200)", test_num);
            voltage_in = 8'd200;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Lower Max Range (240)", test_num);
            voltage_in = 8'd240;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Maximum Input (255)", test_num);
            voltage_in = 8'd255;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Random Input (85)", test_num);
            voltage_in = 8'd85;
            #1;

            check_outputs(4'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8_to_4 Testbench");
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
        input [3:0] expected_voltage_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: voltage_out=%h",
                         voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_out=%h",
                         expected_voltage_out);
                $display("  Got:      voltage_out=%h",
                         voltage_out);
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
