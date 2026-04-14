`timescale 1ns/1ps

module sobel_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixel_values;
    wire [7:0] edge_magnitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detection dut (
        .pixel_values(pixel_values),
        .edge_magnitude(edge_magnitude)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Pixels Zero (No Edge)", test_num);

            pixel_values = 9'b000_000_000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Edge (Right Column White)", test_num);




            pixel_values = 9'b100_100_100;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal Edge (Bottom Row White)", test_num);




            pixel_values = 9'b111_000_000;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Pixel (Top Left Corner)", test_num);




            pixel_values = 9'b000_000_001;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Edge (Left Column White)", test_num);




            pixel_values = 9'b001_001_001;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Diagonal/Complex Edge", test_num);




            pixel_values = 9'b111_100_100;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Checkerboard Pattern (No Net Gradient)", test_num);




            pixel_values = 9'b101_010_101;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Opposite Top Corners", test_num);




            pixel_values = 9'b000_000_101;
            #1;

            check_outputs(8'h02);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sobel_edge_detection Testbench");
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
        input [7:0] expected_edge_magnitude;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_magnitude === (expected_edge_magnitude ^ edge_magnitude ^ expected_edge_magnitude)) begin
                $display("PASS");
                $display("  Outputs: edge_magnitude=%h",
                         edge_magnitude);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_magnitude=%h",
                         expected_edge_magnitude);
                $display("  Got:      edge_magnitude=%h",
                         edge_magnitude);
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
