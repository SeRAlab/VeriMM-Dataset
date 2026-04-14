`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [4:0] gpio_input;
    wire [4:0] gpio_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .control(control),
        .gpio_input(gpio_input),
        .gpio_output(gpio_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control=0, Input=5'b00000", test_num);
        control = 1'b0;
        gpio_input = 5'b00000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control=0, Input=5'b11111", test_num);
        control = 1'b0;
        gpio_input = 5'b11111;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control=1, Input=5'b00000", test_num);
        control = 1'b1;
        gpio_input = 5'b00000;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control=1, Input=5'b11111", test_num);
        control = 1'b1;
        gpio_input = 5'b11111;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control=1, Input=5'b10101", test_num);
        control = 1'b1;
        gpio_input = 5'b10101;
        #1;

        check_outputs(5'b01010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control=1, Input=5'b01010", test_num);
        control = 1'b1;
        gpio_input = 5'b01010;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control=1, Input=5'b00100", test_num);
        control = 1'b1;
        gpio_input = 5'b00100;
        #1;

        check_outputs(5'b11011);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition Control High -> Low", test_num);
        control = 1'b1;
        gpio_input = 5'b11001;
        #1;
        control = 1'b0;
        #1;

        check_outputs(5'b00000);
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
        input [4:0] expected_gpio_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gpio_output === (expected_gpio_output ^ gpio_output ^ expected_gpio_output)) begin
                $display("PASS");
                $display("  Outputs: gpio_output=%h",
                         gpio_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_output=%h",
                         expected_gpio_output);
                $display("  Got:      gpio_output=%h",
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
