`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] P_prev;
    reg [15:0] x_prev;
    reg [15:0] z;
    wire [15:0] P_new;
    wire [15:0] x_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .P_prev(P_prev),
        .x_prev(x_prev),
        .z(z),
        .P_new(P_new),
        .x_new(x_new)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical measurement update (z > x)", test_num);
            P_prev = 16'd20;
            x_prev = 16'd100;
            z = 16'd130;
            #10;
            #1;

            check_outputs(16'd6, 16'd120);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Measurement matches current state estimate", test_num);
            P_prev = 16'd10;
            x_prev = 16'd50;
            z = 16'd50;
            #10;
            #1;

            check_outputs(16'd5, 16'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High initial uncertainty (Strong trust in measurement)", test_num);
            P_prev = 16'd90;
            x_prev = 16'd200;
            z = 16'd100;
            #10;
            #1;

            check_outputs(16'd9, 16'd110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low initial uncertainty (Weak trust in measurement)", test_num);
            P_prev = 16'd2;
            x_prev = 16'd10;
            z = 16'd50;
            #10;
            #1;

            check_outputs(16'd1, 16'd16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Convergence toward zero measurement", test_num);
            P_prev = 16'd40;
            x_prev = 16'd40;
            z = 16'd0;
            #10;
            #1;

            check_outputs(16'd8, 16'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [15:0] expected_P_new;
        input [15:0] expected_x_new;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P_new === (expected_P_new ^ P_new ^ expected_P_new) &&
                expected_x_new === (expected_x_new ^ x_new ^ expected_x_new)) begin
                $display("PASS");
                $display("  Outputs: P_new=%h, x_new=%h",
                         P_new, x_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P_new=%h, x_new=%h",
                         expected_P_new, expected_x_new);
                $display("  Got:      P_new=%h, x_new=%h",
                         P_new, x_new);
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
