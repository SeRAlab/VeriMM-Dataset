`timescale 1ns/1ps

module png_sub_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_pixel;
    reg [7:0] previous_pixel;
    wire [7:0] filtered_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_sub_filter dut (
        .current_pixel(current_pixel),
        .previous_pixel(previous_pixel),
        .filtered_pixel(filtered_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Basic Subtraction (current > previous)", test_num);
            current_pixel = 8'd100;
            previous_pixel = 8'd30;

            #1;


            check_outputs(8'd70);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Equal Values (Result = 0)", test_num);
            current_pixel = 8'd127;
            previous_pixel = 8'd127;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Underflow (current < previous)", test_num);
            current_pixel = 8'd10;
            previous_pixel = 8'd50;

            #1;


            check_outputs(8'd216);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Max Value minus Zero", test_num);
            current_pixel = 8'd255;
            previous_pixel = 8'd0;

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Zero minus Max Value", test_num);
            current_pixel = 8'd0;
            previous_pixel = 8'd255;

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Both zero", test_num);
            current_pixel = 8'd0;
            previous_pixel = 8'd0;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Middle range subtraction", test_num);
            current_pixel = 8'hC0;
            previous_pixel = 8'h40;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Wrap around near limits", test_num);
            current_pixel = 8'd5;
            previous_pixel = 8'd250;

            #1;


            check_outputs(8'd11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_sub_filter Testbench");
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
        input [7:0] expected_filtered_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_filtered_pixel === (expected_filtered_pixel ^ filtered_pixel ^ expected_filtered_pixel)) begin
                $display("PASS");
                $display("  Outputs: filtered_pixel=%h",
                         filtered_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_pixel=%h",
                         expected_filtered_pixel);
                $display("  Got:      filtered_pixel=%h",
                         filtered_pixel);
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
