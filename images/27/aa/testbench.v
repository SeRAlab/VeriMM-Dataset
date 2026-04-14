`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [4:0] gpio_in;
    wire [4:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .enable(enable),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Enable low, Input all ones", test_num);
            enable = 1'b0;
            gpio_in = 5'b11111;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Enable low, Input alternating pattern", test_num);
            enable = 1'b0;
            gpio_in = 5'b10101;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Enable high, Input all zeros", test_num);
            enable = 1'b1;
            gpio_in = 5'b00000;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enable high, Input all ones", test_num);
            enable = 1'b1;
            gpio_in = 5'b11111;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Enable high, Input 10101", test_num);
            enable = 1'b1;
            gpio_in = 5'b10101;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Enable high, Input 01010", test_num);
            enable = 1'b1;
            gpio_in = 5'b01010;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Enable high, Input single bit 00100", test_num);
            enable = 1'b1;
            gpio_in = 5'b00100;
            #1;

            check_outputs(5'b11011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Transition Enable from High to Low", test_num);

            enable = 1'b1;
            gpio_in = 5'b11001;
            #5;

            enable = 1'b0;
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
        input [4:0] expected_gpio_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gpio_out === (expected_gpio_out ^ gpio_out ^ expected_gpio_out)) begin
                $display("PASS");
                $display("  Outputs: gpio_out=%h",
                         gpio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_out=%h",
                         expected_gpio_out);
                $display("  Got:      gpio_out=%h",
                         gpio_out);
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
