`timescale 1ns/1ps

module kmeans_centroid_calc_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire [7:0] centroid_x;
    wire [7:0] centroid_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_centroid_calc dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .centroid_x(centroid_x),
        .centroid_y(centroid_y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple even average", test_num);
            x1 = 8'd10;
            x2 = 8'd20;
            y1 = 8'd30;
            y2 = 8'd40;
            #1;

            check_outputs(8'd15, 8'd35);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Odd sum (truncation check)", test_num);
            x1 = 8'd5;
            x2 = 8'd10;
            y1 = 8'd21;
            y2 = 8'd22;
            #1;

            check_outputs(8'd7, 8'd21);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values", test_num);
            x1 = 8'hFF;
            x2 = 8'hFF;
            y1 = 8'hFF;
            y2 = 8'hFE;
            #1;

            check_outputs(8'hFF, 8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero values", test_num);
            x1 = 8'd0;
            x2 = 8'd0;
            y1 = 8'd0;
            y2 = 8'd1;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range values with carry", test_num);
            x1 = 8'd200;
            x2 = 8'd100;
            y1 = 8'd128;
            y2 = 8'd128;
            #1;

            check_outputs(8'd150, 8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical points", test_num);
            x1 = 8'd42;
            x2 = 8'd42;
            y1 = 8'd123;
            y2 = 8'd123;
            #1;

            check_outputs(8'd42, 8'd123);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating extremes", test_num);
            x1 = 8'd255;
            x2 = 8'd0;
            y1 = 8'd1;
            y2 = 8'd254;
            #1;

            check_outputs(8'd127, 8'd127);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kmeans_centroid_calc Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_centroid_x;
        input [7:0] expected_centroid_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_centroid_x === (expected_centroid_x ^ centroid_x ^ expected_centroid_x) &&
                expected_centroid_y === (expected_centroid_y ^ centroid_y ^ expected_centroid_y)) begin
                $display("PASS");
                $display("  Outputs: centroid_x=%h, centroid_y=%h",
                         centroid_x, centroid_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroid_x=%h, centroid_y=%h",
                         expected_centroid_x, expected_centroid_y);
                $display("  Got:      centroid_x=%h, centroid_y=%h",
                         centroid_x, centroid_y);
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
