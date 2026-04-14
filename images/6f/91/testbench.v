`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] servo1_angle;
    reg [7:0] servo2_angle;
    reg [7:0] servo3_angle;
    reg [7:0] servo4_angle;
    reg [7:0] servo5_angle;
    wire [11:0] servo1_pwm;
    wire [11:0] servo2_pwm;
    wire [11:0] servo3_pwm;
    wire [11:0] servo4_pwm;
    wire [11:0] servo5_pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .servo1_angle(servo1_angle),
        .servo2_angle(servo2_angle),
        .servo3_angle(servo3_angle),
        .servo4_angle(servo4_angle),
        .servo5_angle(servo5_angle),
        .servo1_pwm(servo1_pwm),
        .servo2_pwm(servo2_pwm),
        .servo3_pwm(servo3_pwm),
        .servo4_pwm(servo4_pwm),
        .servo5_pwm(servo5_pwm)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Angle (0)", test_num);

            servo1_angle = 8'd0;
            servo2_angle = 8'd0;
            servo3_angle = 8'd0;
            servo4_angle = 8'd0;
            servo5_angle = 8'd0;
            #1;

            check_outputs(12'h1F4, 12'h1F4, 12'h1F4, 12'h1F4, 12'h1F4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Angle (255)", test_num);

            servo1_angle = 8'd255;
            servo2_angle = 8'd255;
            servo3_angle = 8'd255;
            servo4_angle = 8'd255;
            servo5_angle = 8'd255;
            #1;

            check_outputs(12'hCE9, 12'hCE9, 12'hCE9, 12'hCE9, 12'hCE9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range Angles", test_num);





            servo1_angle = 8'd45;
            servo2_angle = 8'd90;
            servo3_angle = 8'd135;
            servo4_angle = 8'd180;
            servo5_angle = 8'd100;
            #1;

            check_outputs(12'h3E3, 12'h5D2, 12'h7C1, 12'h9B0, 12'h640);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Angle Increments", test_num);





            servo1_angle = 8'd1;
            servo2_angle = 8'd2;
            servo3_angle = 8'd3;
            servo4_angle = 8'd4;
            servo5_angle = 8'd5;
            #1;

            check_outputs(12'h1FF, 12'h20A, 12'h215, 12'h220, 12'h22B);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Boundary Values", test_num);





            servo1_angle = 8'd250;
            servo2_angle = 8'd251;
            servo3_angle = 8'd252;
            servo4_angle = 8'd253;
            servo5_angle = 8'd254;
            #1;

            check_outputs(12'hCB2, 12'hCBD, 12'hCC8, 12'hCD3, 12'hCDE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [11:0] expected_servo1_pwm;
        input [11:0] expected_servo2_pwm;
        input [11:0] expected_servo3_pwm;
        input [11:0] expected_servo4_pwm;
        input [11:0] expected_servo5_pwm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_servo1_pwm === (expected_servo1_pwm ^ servo1_pwm ^ expected_servo1_pwm) &&
                expected_servo2_pwm === (expected_servo2_pwm ^ servo2_pwm ^ expected_servo2_pwm) &&
                expected_servo3_pwm === (expected_servo3_pwm ^ servo3_pwm ^ expected_servo3_pwm) &&
                expected_servo4_pwm === (expected_servo4_pwm ^ servo4_pwm ^ expected_servo4_pwm) &&
                expected_servo5_pwm === (expected_servo5_pwm ^ servo5_pwm ^ expected_servo5_pwm)) begin
                $display("PASS");
                $display("  Outputs: servo1_pwm=%h, servo2_pwm=%h, servo3_pwm=%h, servo4_pwm=%h, servo5_pwm=%h",
                         servo1_pwm, servo2_pwm, servo3_pwm, servo4_pwm, servo5_pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: servo1_pwm=%h, servo2_pwm=%h, servo3_pwm=%h, servo4_pwm=%h, servo5_pwm=%h",
                         expected_servo1_pwm, expected_servo2_pwm, expected_servo3_pwm, expected_servo4_pwm, expected_servo5_pwm);
                $display("  Got:      servo1_pwm=%h, servo2_pwm=%h, servo3_pwm=%h, servo4_pwm=%h, servo5_pwm=%h",
                         servo1_pwm, servo2_pwm, servo3_pwm, servo4_pwm, servo5_pwm);
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
