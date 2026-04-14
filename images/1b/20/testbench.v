`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] x_next;
    wire [15:0] y_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .x(x),
        .y(y),
        .x_next(x_next),
        .y_next(y_next)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (0, 0)", test_num);
            x = 16'sd0;
            y = 16'sd0;
            #1;

            check_outputs(16'sd0, 16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (10, 20)", test_num);
            x = 16'sd10;
            y = 16'sd20;
            #1;

            check_outputs(16'sd8, 16'sd16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (-10, -30)", test_num);
            x = -16'sd10;
            y = -16'sd30;
            #1;

            check_outputs(16'hFFF8, 16'hFFE8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (100, -50)", test_num);
            x = 16'sd100;
            y = -16'sd50;
            #1;

            check_outputs(16'sd80, 16'hFFD8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (-1000, 500)", test_num);
            x = -16'sd1000;
            y = 16'sd500;
            #1;

            check_outputs(16'hFCE0, 16'sd400);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_x_next;
        input [15:0] expected_y_next;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_next === (expected_x_next ^ x_next ^ expected_x_next) &&
                expected_y_next === (expected_y_next ^ y_next ^ expected_y_next)) begin
                $display("PASS");
                $display("  Outputs: x_next=%h, y_next=%h",
                         x_next, y_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_next=%h, y_next=%h",
                         expected_x_next, expected_y_next);
                $display("  Got:      x_next=%h, y_next=%h",
                         x_next, y_next);
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
