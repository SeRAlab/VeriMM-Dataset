`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    reg [7:0] y;
    wire is_inside;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .x(x),
        .y(y),
        .is_inside(is_inside)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Origin (0, 0)");
        x = 8'd0;
        y = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Maximum X Boundary (255, 0)");
        x = 8'd255;
        y = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Maximum Y Boundary (0, 255)");
        x = 8'd0;
        y = 8'd255;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Square Corner (255, 255)");
        x = 8'd255;
        y = 8'd255;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Mid-point (128, 128)");
        x = 8'd128;
        y = 8'd128;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Near Boundary Inside (180, 180)");
        x = 8'd180;
        y = 8'd180;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Near Boundary Outside (181, 181)");
        x = 8'd181;
        y = 8'd181;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Specific Point Inside (200, 158)");
        x = 8'd200;
        y = 8'd158;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Specific Point Outside (200, 159)");
        x = 8'd200;
        y = 8'd159;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Just Outside X-Axis (255, 1)");
        x = 8'd255;
        y = 8'd1;
        #1;

        check_outputs(1'b0);
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
        input expected_is_inside;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_inside === (expected_is_inside ^ is_inside ^ expected_is_inside)) begin
                $display("PASS");
                $display("  Outputs: is_inside=%b",
                         is_inside);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_inside=%b",
                         expected_is_inside);
                $display("  Got:      is_inside=%b",
                         is_inside);
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
