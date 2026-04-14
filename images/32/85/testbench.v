`timescale 1ns/1ps

module canny_threshold_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] high_threshold;
    reg [7:0] low_threshold;
    reg [7:0] pixel_value;
    wire edge_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    canny_threshold dut (
        .high_threshold(high_threshold),
        .low_threshold(low_threshold),
        .pixel_value(pixel_value),
        .edge_detected(edge_detected)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pixel below low threshold", test_num);
            high_threshold = 8'd200;
            low_threshold  = 8'd100;
            pixel_value    = 8'd50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pixel exactly at low threshold", test_num);
            high_threshold = 8'd200;
            low_threshold  = 8'd100;
            pixel_value    = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pixel between thresholds", test_num);
            high_threshold = 8'd200;
            low_threshold  = 8'd100;
            pixel_value    = 8'd150;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pixel exactly at high threshold", test_num);
            high_threshold = 8'd200;
            low_threshold  = 8'd100;
            pixel_value    = 8'd200;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pixel above high threshold", test_num);
            high_threshold = 8'd200;
            low_threshold  = 8'd100;
            pixel_value    = 8'd250;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Thresholds equal, pixel below", test_num);
            high_threshold = 8'd128;
            low_threshold  = 8'd128;
            pixel_value    = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Thresholds equal, pixel above", test_num);
            high_threshold = 8'd128;
            low_threshold  = 8'd128;
            pixel_value    = 8'd150;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All zero inputs", test_num);
            high_threshold = 8'd0;
            low_threshold  = 8'd0;
            pixel_value    = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max value thresholding", test_num);
            high_threshold = 8'd255;
            low_threshold  = 8'd255;
            pixel_value    = 8'd254;
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
        $display("canny_threshold Testbench");
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
        input expected_edge_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_detected === (expected_edge_detected ^ edge_detected ^ expected_edge_detected)) begin
                $display("PASS");
                $display("  Outputs: edge_detected=%b",
                         edge_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_detected=%b",
                         expected_edge_detected);
                $display("  Got:      edge_detected=%b",
                         edge_detected);
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
