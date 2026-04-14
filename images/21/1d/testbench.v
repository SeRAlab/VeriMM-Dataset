`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] learning_rate;
    reg [15:0] x_current;
    wire [15:0] x_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .learning_rate(learning_rate),
        .x_current(x_current),
        .x_new(x_new)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero learning rate", test_num);
            learning_rate = 16'h0000;
            x_current = 16'h0064;
            #1;

            check_outputs(16'h0064);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Zero current value", test_num);
            learning_rate = 16'h0005;
            x_current = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Step result in negative value (x=50, lr=1)", test_num);
            learning_rate = 16'h0001;
            x_current = 16'h0032;
            #1;

            check_outputs(16'hFFCE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Large learning rate (x=10, lr=2)", test_num);
            learning_rate = 16'h0002;
            x_current = 16'h000A;
            #1;

            check_outputs(16'hFFE2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High LR, small X (x=1, lr=10)", test_num);
            learning_rate = 16'h000A;
            x_current = 16'h0001;
            #1;

            check_outputs(16'hFFED);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simple integer step (x=5, lr=1)", test_num);
            learning_rate = 16'h0001;
            x_current = 16'h0005;
            #1;

            check_outputs(16'hFFFB);
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
        testcase006();
        
        
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
        input [15:0] expected_x_new;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_new === (expected_x_new ^ x_new ^ expected_x_new)) begin
                $display("PASS");
                $display("  Outputs: x_new=%h",
                         x_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_new=%h",
                         expected_x_new);
                $display("  Got:      x_new=%h",
                         x_new);
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
