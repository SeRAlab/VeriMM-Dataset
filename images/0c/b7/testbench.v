`timescale 1ns/1ps

module png_compression_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_pixel;
    reg [3:0] previous_pixel;
    wire [3:0] differenced_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compression dut (
        .current_pixel(current_pixel),
        .previous_pixel(previous_pixel),
        .differenced_value(differenced_value)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical pixels (5, 5)", test_num);
            current_pixel = 4'd5;
            previous_pixel = 4'd5;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive difference (10, 3)", test_num);
            current_pixel = 4'd10;
            previous_pixel = 4'd3;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative difference with wrap-around (3, 10)", test_num);
            current_pixel = 4'd3;
            previous_pixel = 4'd10;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum difference (15, 0)", test_num);
            current_pixel = 4'd15;
            previous_pixel = 4'd0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum negative difference wrap-around (0, 15)", test_num);
            current_pixel = 4'd0;
            previous_pixel = 4'd15;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values (15, 15)", test_num);
            current_pixel = 4'd15;
            previous_pixel = 4'd15;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero values (0, 0)", test_num);
            current_pixel = 4'd0;
            previous_pixel = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small positive step (8, 7)", test_num);
            current_pixel = 4'd8;
            previous_pixel = 4'd7;
            #1;

            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_compression Testbench");
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
        input [3:0] expected_differenced_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_differenced_value === (expected_differenced_value ^ differenced_value ^ expected_differenced_value)) begin
                $display("PASS");
                $display("  Outputs: differenced_value=%h",
                         differenced_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: differenced_value=%h",
                         expected_differenced_value);
                $display("  Got:      differenced_value=%h",
                         differenced_value);
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
