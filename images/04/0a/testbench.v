`timescale 1ns/1ps

module sobel_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bottom_pixel;
    reg [7:0] left_pixel;
    reg [7:0] pixel;
    reg [7:0] right_pixel;
    reg [7:0] top_pixel;
    wire [7:0] edge_strength;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detection dut (
        .bottom_pixel(bottom_pixel),
        .left_pixel(left_pixel),
        .pixel(pixel),
        .right_pixel(right_pixel),
        .top_pixel(top_pixel),
        .edge_strength(edge_strength)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Pixels Zero", test_num);
        top_pixel = 8'd0; bottom_pixel = 8'd0; left_pixel = 8'd0; right_pixel = 8'd0; pixel = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Pixels Max (255)", test_num);
        top_pixel = 8'd255; bottom_pixel = 8'd255; left_pixel = 8'd255; right_pixel = 8'd255; pixel = 8'd255;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Strong Vertical Edge (Gx max)", test_num);
        top_pixel = 8'd128; bottom_pixel = 8'd128; left_pixel = 8'd0; right_pixel = 8'd255; pixel = 8'd128;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Strong Horizontal Edge (Gy max)", test_num);
        top_pixel = 8'd255; bottom_pixel = 8'd0; left_pixel = 8'd128; right_pixel = 8'd128; pixel = 8'd128;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Gradients (X dominant)", test_num);
        top_pixel = 8'd100; bottom_pixel = 8'd150; left_pixel = 8'd50; right_pixel = 8'd200; pixel = 8'd125;


        #1;



        check_outputs(8'd150);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Gradients (Y dominant)", test_num);
        top_pixel = 8'd20; bottom_pixel = 8'd220; left_pixel = 8'd100; right_pixel = 8'd180; pixel = 8'd50;


        #1;



        check_outputs(8'd200);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative difference check (Absolute Value)", test_num);
        top_pixel = 8'd100; bottom_pixel = 8'd100; left_pixel = 8'd200; right_pixel = 8'd50; pixel = 8'd100;


        #1;



        check_outputs(8'd150);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative difference check Y (Absolute Value)", test_num);
        top_pixel = 8'd250; bottom_pixel = 8'd10; left_pixel = 8'd128; right_pixel = 8'd128; pixel = 8'd128;


        #1;



        check_outputs(8'd240);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Center Pixel Independence check", test_num);
        top_pixel = 8'd50; bottom_pixel = 8'd150; left_pixel = 8'd50; right_pixel = 8'd150;


        pixel = 8'd0;
        #1;

        if (edge_strength == 8'd100) begin

            pixel = 8'd255;
            #1;

            check_outputs(8'd100);
        end else begin
            #1;

            check_outputs(8'd100);
        end
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtle Edge detection", test_num);
        top_pixel = 8'd45; bottom_pixel = 8'd50; left_pixel = 8'd40; right_pixel = 8'd48; pixel = 8'd45;


        #1;



        check_outputs(8'd8);
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
        input [7:0] expected_edge_strength;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_strength === (expected_edge_strength ^ edge_strength ^ expected_edge_strength)) begin
                $display("PASS");
                $display("  Outputs: edge_strength=%h",
                         edge_strength);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_strength=%h",
                         expected_edge_strength);
                $display("  Got:      edge_strength=%h",
                         edge_strength);
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
