`timescale 1ns/1ps

module adc_inverter_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] analog_in;
    wire [23:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_inverter dut (
        .analog_in(analog_in),
        .digital_out(digital_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Input", test_num);
            analog_in = 24'h000000;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Input", test_num);
            analog_in = 24'hFFFFFF;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Pattern 1 (555555)", test_num);
            analog_in = 24'h555555;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Pattern 2 (AAAAAA)", test_num);
            analog_in = 24'hAAAAAA;
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking One MSB", test_num);
            analog_in = 24'h800000;
            #1;

            check_outputs(24'h7FFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking One LSB", test_num);
            analog_in = 24'h000001;
            #1;

            check_outputs(24'hFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Pattern 1 (123456)", test_num);
            analog_in = 24'h123456;
            #1;

            check_outputs(24'hEDCBA9);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Pattern 2 (CAFEB0)", test_num);
            analog_in = 24'hCAFEB0;
            #1;

            check_outputs(24'h35014F);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower Byte Full", test_num);
            analog_in = 24'h0000FF;
            #1;

            check_outputs(24'hFFFF00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle Byte Full", test_num);
            analog_in = 24'h00FF00;
            #1;

            check_outputs(24'hFF00FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_inverter Testbench");
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
        input [23:0] expected_digital_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_out === (expected_digital_out ^ digital_out ^ expected_digital_out)) begin
                $display("PASS");
                $display("  Outputs: digital_out=%h",
                         digital_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_out=%h",
                         expected_digital_out);
                $display("  Got:      digital_out=%h",
                         digital_out);
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
