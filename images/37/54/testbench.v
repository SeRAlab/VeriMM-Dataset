`timescale 1ns/1ps

module dac_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] digital_input;
    wire [11:0] pwm_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_16bit dut (
        .digital_input(digital_input),
        .pwm_output(pwm_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Input (0x0000)", test_num);
            digital_input = 16'h0000;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Input (0xFFFF)", test_num);
            digital_input = 16'hFFFF;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Midpoint Input (0x8000)", test_num);
            digital_input = 16'h8000;
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Quarter Scale Input (0x4000)", test_num);
            digital_input = 16'h4000;
            #1;

            check_outputs(12'h400);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Three-Quarter Scale Input (0xC000)", test_num);
            digital_input = 16'hC000;
            #1;

            check_outputs(12'hC00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern Input (0xA5A5)", test_num);
            digital_input = 16'hA5A5;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value Low (0x000F)", test_num);
            digital_input = 16'h000F;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value Step (0x0010)", test_num);
            digital_input = 16'h0010;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternate Bit Pattern (0x5555)", test_num);
            digital_input = 16'h5555;
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Range Value (0xE38C)", test_num);
            digital_input = 16'hE38C;
            #1;

            check_outputs(12'hE38);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_16bit Testbench");
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
        input [11:0] expected_pwm_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pwm_output === (expected_pwm_output ^ pwm_output ^ expected_pwm_output)) begin
                $display("PASS");
                $display("  Outputs: pwm_output=%h",
                         pwm_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_output=%h",
                         expected_pwm_output);
                $display("  Got:      pwm_output=%h",
                         pwm_output);
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
