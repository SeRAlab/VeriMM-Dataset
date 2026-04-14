`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] point_x;
    reg [4:0] point_y;
    wire inside_circle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .point_x(point_x),
        .point_y(point_y),
        .inside_circle(inside_circle)
    );
    task testcase001;

        begin
            test_num = 1;
            point_x = 5'd0;
            point_y = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            point_x = 5'd31;
            point_y = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            point_x = 5'd0;
            point_y = 5'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            point_x = 5'd31;
            point_y = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            point_x = 5'd15;
            point_y = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            point_x = 5'd21;
            point_y = 5'd21;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            point_x = 5'd22;
            point_y = 5'd22;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            point_x = 5'd30;
            point_y = 5'd7;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            point_x = 5'd30;
            point_y = 5'd8;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            point_x = 5'd1;
            point_y = 5'd1;
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
        $display("monte_carlo_pi Testbench");
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
        input expected_inside_circle;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inside_circle === (expected_inside_circle ^ inside_circle ^ expected_inside_circle)) begin
                $display("PASS");
                $display("  Outputs: inside_circle=%b",
                         inside_circle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inside_circle=%b",
                         expected_inside_circle);
                $display("  Got:      inside_circle=%b",
                         inside_circle);
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
