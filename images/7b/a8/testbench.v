`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] Ball_S;
    reg [9:0] Ball_X;
    reg [9:0] Ball_Y;
    reg [9:0] VGA_X;
    reg [9:0] VGA_Y;
    wire [9:0] VGA_B;
    wire [9:0] VGA_G;
    wire [9:0] VGA_R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ball_S(Ball_S),
        .Ball_X(Ball_X),
        .Ball_Y(Ball_Y),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_B(VGA_B),
        .VGA_G(VGA_G),
        .VGA_R(VGA_R)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Pixel at ball center", test_num);
        Ball_X = 10'd320; Ball_Y = 10'd240; Ball_S = 10'd15;
        VGA_X = 10'd320; VGA_Y = 10'd240;

        #1;


        check_outputs(10'h3ff, 10'h3ff, 10'h3ff);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Pixel at ball vertical edge", test_num);
        Ball_X = 10'd320; Ball_Y = 10'd240; Ball_S = 10'd15;
        VGA_X = 10'd320; VGA_Y = 10'd255;

        #1;


        check_outputs(10'h3ff, 10'h3ff, 10'h3ff);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Pixel just outside the ball radius", test_num);
        Ball_X = 10'd320; Ball_Y = 10'd240; Ball_S = 10'd15;
        VGA_X = 10'd320; VGA_Y = 10'd256;


        #1;



        check_outputs(10'h3ff - 10'd320, 10'h000, 10'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Diagonal pixel inside the circle", test_num);
        Ball_X = 10'd200; Ball_Y = 10'd200; Ball_S = 10'd10;
        VGA_X = 10'd207; VGA_Y = 10'd207;


        #1;



        check_outputs(10'h3ff, 10'h3ff, 10'h3ff);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Diagonal pixel just outside the circle", test_num);
        Ball_X = 10'd200; Ball_Y = 10'd200; Ball_S = 10'd10;
        VGA_X = 10'd208; VGA_Y = 10'd208;


        #1;



        check_outputs(10'h3ff - 10'd208, 10'h000, 10'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Ball at origin (0,0), Pixel inside", test_num);
        Ball_X = 10'd0; Ball_Y = 10'd0; Ball_S = 10'd50;
        VGA_X = 10'd30; VGA_Y = 10'd40;


        #1;



        check_outputs(10'h3ff, 10'h3ff, 10'h3ff);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: Pixel far from ball", test_num);
        Ball_X = 10'd500; Ball_Y = 10'd400; Ball_S = 10'd5;
        VGA_X = 10'd10; VGA_Y = 10'd10;

        #1;


        check_outputs(10'h3ff - 10'd10, 10'h000, 10'h000);
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
        input [9:0] expected_VGA_B;
        input [9:0] expected_VGA_G;
        input [9:0] expected_VGA_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VGA_B === (expected_VGA_B ^ VGA_B ^ expected_VGA_B) &&
                expected_VGA_G === (expected_VGA_G ^ VGA_G ^ expected_VGA_G) &&
                expected_VGA_R === (expected_VGA_R ^ VGA_R ^ expected_VGA_R)) begin
                $display("PASS");
                $display("  Outputs: VGA_B=%h, VGA_G=%h, VGA_R=%h",
                         VGA_B, VGA_G, VGA_R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGA_B=%h, VGA_G=%h, VGA_R=%h",
                         expected_VGA_B, expected_VGA_G, expected_VGA_R);
                $display("  Got:      VGA_B=%h, VGA_G=%h, VGA_R=%h",
                         VGA_B, VGA_G, VGA_R);
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
