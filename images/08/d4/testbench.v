`timescale 1ns/1ps

module adc_16_to_4_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] analog_in;
    wire [3:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_16_to_4 dut (
        .analog_in(analog_in),
        .digital_out(digital_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum input", test_num);
            analog_in = 16'h0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum input", test_num);
            analog_in = 16'hFFFF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition point (just below 1)", test_num);
            analog_in = 16'h0FFF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition point (exactly 1)", test_num);
            analog_in = 16'h1000;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range value (around half)", test_num);
            analog_in = 16'h8000;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Quarter scale", test_num);
            analog_in = 16'h4000;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three-quarter scale", test_num);
            analog_in = 16'hC000;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random value 1", test_num);
            analog_in = 16'hA5A5;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random value 2", test_num);
            analog_in = 16'h5555;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary of max value", test_num);
            analog_in = 16'hF000;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_16_to_4 Testbench");
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
        input [3:0] expected_digital_out;
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
