`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg gpio_input;
    reg reset;
    wire gpio_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .control(control),
        .gpio_input(gpio_input),
        .reset(reset),
        .gpio_output(gpio_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset high force output low", test_num);

            reset = 1;
            control = 1;
            gpio_input = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Control high, pass input high to output", test_num);

            reset = 1;
            #5;
            reset = 0;

            control = 1;
            gpio_input = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Control high, pass input low to output", test_num);

            reset = 1;
            #5;
            reset = 0;

            control = 1;
            gpio_input = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Control low, latch high state", test_num);

            reset = 1;
            #5;
            reset = 0;

            control = 1;
            gpio_input = 1;
            #5;

            control = 0;
            #5;

            gpio_input = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Control low, latch low state", test_num);

            reset = 1;
            #5;
            reset = 0;

            control = 1;
            gpio_input = 0;
            #5;

            control = 0;
            #5;

            gpio_input = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Reset dominance over control and input", test_num);

            reset = 1;
            #5;
            reset = 0;
            control = 1;
            gpio_input = 1;
            #5;


            reset = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Input toggling while control is low", test_num);

            reset = 1;
            #5;
            reset = 0;

            control = 1;
            gpio_input = 1;
            #5;

            control = 0;
            #5;

            gpio_input = 0; #5;
            gpio_input = 1; #5;
            gpio_input = 0; #5;
            gpio_input = 1; #5;

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_gpio_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gpio_output === (expected_gpio_output ^ gpio_output ^ expected_gpio_output)) begin
                $display("PASS");
                $display("  Outputs: gpio_output=%b",
                         gpio_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_output=%b",
                         expected_gpio_output);
                $display("  Got:      gpio_output=%b",
                         gpio_output);
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
