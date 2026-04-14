`timescale 1ns/1ps

module paeth_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] above_left_pixel;
    reg [7:0] above_pixel;
    reg [7:0] current_pixel;
    reg [7:0] left_pixel;
    wire [7:0] predicted_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    paeth_filter dut (
        .above_left_pixel(above_left_pixel),
        .above_pixel(above_pixel),
        .current_pixel(current_pixel),
        .left_pixel(left_pixel),
        .predicted_pixel(predicted_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All pixels identical", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd50;
            above_pixel = 8'd50;
            left_pixel = 8'd50;
            #10;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left identical to Above-Left (a=c)", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd100;
            above_pixel      = 8'd150;
            left_pixel       = 8'd100;
            #10;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Above identical to Above-Left (b=c)", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd80;
            above_pixel      = 8'd80;
            left_pixel       = 8'd120;
            #10;
            #1;

            check_outputs(8'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Predict Left", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd50;
            above_pixel      = 8'd50;
            left_pixel       = 8'd100;
            #10;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Predict Above", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd50;
            above_pixel      = 8'd100;
            left_pixel       = 8'd50;
            #10;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Predict Above-Left", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd50;
            above_pixel      = 8'd10;
            left_pixel       = 8'd100;
            #10;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Tie-break Left vs Above (pa=pb)", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd10;
            above_pixel      = 8'd50;
            left_pixel       = 8'd50;
            #10;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Tie-break Above vs Above-Left (pb=pc)", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd40;
            above_pixel      = 8'd20;
            left_pixel       = 8'd50;
            #10;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'hFF;
            above_pixel      = 8'hFF;
            left_pixel       = 8'hFF;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gradient case (c wins)", test_num);
            above_left_pixel = 0; above_pixel = 0; left_pixel = 0; current_pixel = 0;
            #10;
            above_left_pixel = 8'd20;
            above_pixel      = 8'd30;
            left_pixel       = 8'd10;
            #10;
            #1;

            check_outputs(8'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("paeth_filter Testbench");
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
        input [7:0] expected_predicted_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_predicted_pixel === (expected_predicted_pixel ^ predicted_pixel ^ expected_predicted_pixel)) begin
                $display("PASS");
                $display("  Outputs: predicted_pixel=%h",
                         predicted_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_pixel=%h",
                         expected_predicted_pixel);
                $display("  Got:      predicted_pixel=%h",
                         predicted_pixel);
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
