`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x_current;
    wire [3:0] x_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .x_current(x_current),
        .x_next(x_next)
    );
    task testcase001;

        begin
            test_num = 1;
            x_current = 4'd3;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x_current = 4'd0;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x_current = 4'd6;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x_current = 4'd1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x_current = 4'd5;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x_current = 4'd2;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x_current = 4'd4;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x_current = 4'd7;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            x_current = 4'd10;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            x_current = 4'd15;
            #1;

            check_outputs(4'd7);
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
        input [3:0] expected_x_next;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_next === (expected_x_next ^ x_next ^ expected_x_next)) begin
                $display("PASS");
                $display("  Outputs: x_next=%h",
                         x_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_next=%h",
                         expected_x_next);
                $display("  Got:      x_next=%h",
                         x_next);
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
