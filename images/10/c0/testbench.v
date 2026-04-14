`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg valid;
    reg [7:0] x_in;
    reg [7:0] y_in;
    wire line_detected;
    wire [7:0] r_out;
    wire [7:0] theta_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .valid(valid),
        .x_in(x_in),
        .y_in(y_in),
        .line_detected(line_detected),
        .r_out(r_out),
        .theta_out(theta_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Detect Vertical Line (theta = 0)", test_num);
            valid = 1'b1;
            x_in = 8'd45;
            y_in = 8'd120;

            #1;


            check_outputs(1'b1, 8'd45, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Detect Horizontal Line (theta = 90)", test_num);
            valid = 1'b1;
            x_in = 8'd200;
            y_in = 8'd75;

            #1;


            check_outputs(1'b1, 8'd75, 8'd90);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid Signal Low (No Detection)", test_num);
            valid = 1'b0;
            x_in = 8'd10;
            y_in = 8'd10;

            #1;


            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Case - Origin Point (0,0)", test_num);
            valid = 1'b1;
            x_in = 8'd0;
            y_in = 8'd0;

            #1;


            check_outputs(1'b1, 8'd0, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Case - Maximum Coordinates (255, 255)", test_num);
            valid = 1'b1;
            x_in = 8'd255;
            y_in = 8'd255;

            #1;


            check_outputs(1'b1, 8'd255, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Another Horizontal Detection", test_num);
            valid = 1'b1;
            x_in = 8'd15;
            y_in = 8'd255;

            #1;


            check_outputs(1'b1, 8'd255, 8'd90);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hough_transform Testbench");
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
        input expected_line_detected;
        input [7:0] expected_r_out;
        input [7:0] expected_theta_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_line_detected === (expected_line_detected ^ line_detected ^ expected_line_detected) &&
                expected_r_out === (expected_r_out ^ r_out ^ expected_r_out) &&
                expected_theta_out === (expected_theta_out ^ theta_out ^ expected_theta_out)) begin
                $display("PASS");
                $display("  Outputs: line_detected=%b, r_out=%h, theta_out=%h",
                         line_detected, r_out, theta_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: line_detected=%b, r_out=%h, theta_out=%h",
                         expected_line_detected, expected_r_out, expected_theta_out);
                $display("  Got:      line_detected=%b, r_out=%h, theta_out=%h",
                         line_detected, r_out, theta_out);
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
