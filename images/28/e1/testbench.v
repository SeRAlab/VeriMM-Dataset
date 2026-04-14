`timescale 1ns/1ps

module downsample_2x2_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel1;
    reg [7:0] pixel2;
    reg [7:0] pixel3;
    reg [7:0] pixel4;
    wire [3:0] avg_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    downsample_2x2 dut (
        .pixel1(pixel1),
        .pixel2(pixel2),
        .pixel3(pixel3),
        .pixel4(pixel4),
        .avg_pixel(avg_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            pixel1 = 8'd0;
            pixel2 = 8'd0;
            pixel3 = 8'd0;
            pixel4 = 8'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All 255s", test_num);
            pixel1 = 8'd255;
            pixel2 = 8'd255;
            pixel3 = 8'd255;
            pixel4 = 8'd255;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sum is 64", test_num);
            pixel1 = 8'd16;
            pixel2 = 8'd16;
            pixel3 = 8'd16;
            pixel4 = 8'd16;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sum is 63 (Rounding down)", test_num);
            pixel1 = 8'd63;
            pixel2 = 8'd0;
            pixel3 = 8'd0;
            pixel4 = 8'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sum is 512", test_num);
            pixel1 = 8'd128;
            pixel2 = 8'd128;
            pixel3 = 8'd128;
            pixel4 = 8'd128;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sum is 1000", test_num);
            pixel1 = 8'd250;
            pixel2 = 8'd250;
            pixel3 = 8'd250;
            pixel4 = 8'd250;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed values (Result 6)", test_num);
            pixel1 = 8'd100;
            pixel2 = 8'd100;
            pixel3 = 8'd100;
            pixel4 = 8'd100;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Gradient values (Result 3)", test_num);
            pixel1 = 8'd10;
            pixel2 = 8'd40;
            pixel3 = 8'd70;
            pixel4 = 8'd100;
            #1;

            check_outputs(4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("downsample_2x2 Testbench");
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
        input [3:0] expected_avg_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_avg_pixel === (expected_avg_pixel ^ avg_pixel ^ expected_avg_pixel)) begin
                $display("PASS");
                $display("  Outputs: avg_pixel=%h",
                         avg_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avg_pixel=%h",
                         expected_avg_pixel);
                $display("  Got:      avg_pixel=%h",
                         avg_pixel);
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
