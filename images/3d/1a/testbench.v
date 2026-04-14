`timescale 1ns/1ps

module canny_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_value;
    reg [7:0] threshold;
    wire edge_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    canny_edge_detection dut (
        .pixel_value(pixel_value),
        .threshold(threshold),
        .edge_flag(edge_flag)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Pixel below threshold", test_num);
            pixel_value = 8'd100;
            threshold = 8'd150;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Pixel exactly at threshold", test_num);
            pixel_value = 8'd150;
            threshold = 8'd150;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Pixel above threshold", test_num);
            pixel_value = 8'd200;
            threshold = 8'd150;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Pixel is zero, threshold is non-zero", test_num);
            pixel_value = 8'd0;
            threshold = 8'd1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Pixel is 255, threshold is 255", test_num);
            pixel_value = 8'd255;
            threshold = 8'd255;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Threshold is zero", test_num);
            pixel_value = 8'd50;
            threshold = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Pixel is 254, threshold is 255", test_num);
            pixel_value = 8'd254;
            threshold = 8'd255;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Zero pixel and zero threshold", test_num);
            pixel_value = 8'd0;
            threshold = 8'd0;
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
        $display("canny_edge_detection Testbench");
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
        input expected_edge_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_flag === (expected_edge_flag ^ edge_flag ^ expected_edge_flag)) begin
                $display("PASS");
                $display("  Outputs: edge_flag=%b",
                         edge_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_flag=%b",
                         expected_edge_flag);
                $display("  Got:      edge_flag=%b",
                         edge_flag);
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
