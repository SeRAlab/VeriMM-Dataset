`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] ball_x;
    reg [9:0] ball_y;
    reg [9:0] paddle_one_x;
    reg [9:0] paddle_one_y;
    reg [9:0] paddle_two_x;
    reg [9:0] paddle_two_y;
    reg [9:0] xpixel;
    reg [9:0] ypixel;
    wire [1:0] blue;
    wire [2:0] green;
    wire [2:0] red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ball_x(ball_x),
        .ball_y(ball_y),
        .paddle_one_x(paddle_one_x),
        .paddle_one_y(paddle_one_y),
        .paddle_two_x(paddle_two_x),
        .paddle_two_y(paddle_two_y),
        .xpixel(xpixel),
        .ypixel(ypixel),
        .blue(blue),
        .green(green),
        .red(red)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing pixel inside the ball bounds", test_num);

            ball_x = 10'd100;
            ball_y = 10'd100;
            paddle_one_x = 10'd20;
            paddle_one_y = 10'd200;
            paddle_two_x = 10'd600;
            paddle_two_y = 10'd200;

            xpixel = 10'd105;
            ypixel = 10'd105;


            #1;



            check_outputs(2'b11, 3'b111, 3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing pixel inside Paddle 1 bounds", test_num);
            ball_x = 10'd300;
            ball_y = 10'd300;
            paddle_one_x = 10'd40;
            paddle_one_y = 10'd150;
            paddle_two_x = 10'd600;
            paddle_two_y = 10'd150;

            xpixel = 10'd45;
            ypixel = 10'd170;


            #1;



            check_outputs(2'b11, 3'b111, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing pixel inside Paddle 2 bounds", test_num);
            ball_x = 10'd300;
            ball_y = 10'd300;
            paddle_one_x = 10'd40;
            paddle_one_y = 10'd150;
            paddle_two_x = 10'd620;
            paddle_two_y = 10'd150;

            xpixel = 10'd625;
            ypixel = 10'd170;

            #1;


            check_outputs(2'b11, 3'b111, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing gradient area (left threshold)", test_num);
            ball_x = 10'd300;
            ball_y = 10'd300;

            xpixel = 10'd5;
            ypixel = 10'd50;




            #1;





            check_outputs(2'b01, 3'b001, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing background area (bottom threshold)", test_num);
            ball_x = 10'd300;
            ball_y = 10'd300;

            xpixel = 10'd400;
            ypixel = 10'd470;


            #1;



            check_outputs(2'b11, 3'b110, 3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing default background (center screen)", test_num);
            ball_x = 10'd100;
            ball_y = 10'd100;
            paddle_one_x = 10'd10;
            paddle_one_y = 10'd10;

            xpixel = 10'd320;
            ypixel = 10'd240;


            #1;



            check_outputs(2'b00, 3'b000, 3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [1:0] expected_blue;
        input [2:0] expected_green;
        input [2:0] expected_red;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, red=%h",
                         blue, green, red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, red=%h",
                         expected_blue, expected_green, expected_red);
                $display("  Got:      blue=%h, green=%h, red=%h",
                         blue, green, red);
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
