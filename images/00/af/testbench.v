`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (combinational circuit)
    reg disturbance;
    reg [3:0] prev_control;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .disturbance(disturbance),
        .prev_control(prev_control),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Disturbance low, input 0", test_num);
            disturbance = 1'b0;
            prev_control = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Disturbance high, 0 increment to 1", test_num);
            disturbance = 1'b1;
            prev_control = 4'h0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Disturbance low, input 10", test_num);
            disturbance = 1'b0;
            prev_control = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Disturbance high, 10 increment to 11", test_num);
            disturbance = 1'b1;
            prev_control = 4'hA;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Disturbance high, wrap-around from 15 to 0", test_num);
            disturbance = 1'b1;
            prev_control = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Disturbance low, maintain 15", test_num);
            disturbance = 1'b0;
            prev_control = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Disturbance high, mid-range increment 7 to 8", test_num);
            disturbance = 1'b1;
            prev_control = 4'h7;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Disturbance low, maintain 3", test_num);
            disturbance = 1'b0;
            prev_control = 4'h3;
            #1;

            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
        input [3:0] expected_control_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
