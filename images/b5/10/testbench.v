`timescale 1ns/1ps

module motor_control_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg s;
    wire motor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    motor_control dut (
        .r(r),
        .s(s),
        .motor(motor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: r=1, s=1", test_num);
            r = 1;
            s = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: r=1, s=0", test_num);
            r = 1;
            s = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: r=0, s=1", test_num);
            r = 0;
            s = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: r=0, s=0", test_num);
            r = 0;
            s = 0;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("motor_control Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_motor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_motor === (expected_motor ^ motor ^ expected_motor)) begin
                $display("PASS");
                $display("  Outputs: motor=%b",
                         motor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: motor=%b",
                         expected_motor);
                $display("  Got:      motor=%b",
                         motor);
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
