`timescale 1ns/1ps

module canny_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel1;
    reg [7:0] pixel2;
    reg [7:0] pixel3;
    reg [7:0] pixel4;
    wire [9:0] gradient_magnitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    canny_edge_detection dut (
        .pixel1(pixel1),
        .pixel2(pixel2),
        .pixel3(pixel3),
        .pixel4(pixel4),
        .gradient_magnitude(gradient_magnitude)
    );
    task testcase001;

    begin
        $display("Testcase 001: All pixels zero");
        test_num = 1;
        pixel1 = 8'd0;
        pixel2 = 8'd0;
        pixel3 = 8'd0;
        pixel4 = 8'd0;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Uniform image (no gradient)");
        test_num = 2;
        pixel1 = 8'd128;
        pixel2 = 8'd128;
        pixel3 = 8'd128;
        pixel4 = 8'd128;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Maximum uniform image");
        test_num = 3;
        pixel1 = 8'd255;
        pixel2 = 8'd255;
        pixel3 = 8'd255;
        pixel4 = 8'd255;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Simple horizontal edge");
        test_num = 4;
        pixel1 = 8'd0;
        pixel2 = 8'd0;
        pixel3 = 8'd100;
        pixel4 = 8'd100;

        #1;


        check_outputs(10'd200);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Simple vertical edge");
        test_num = 5;
        pixel1 = 8'd0;
        pixel2 = 8'd100;
        pixel3 = 8'd0;
        pixel4 = 8'd100;

        #1;


        check_outputs(10'd200);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Single pixel pulse (top-left)");
        test_num = 6;
        pixel1 = 8'd255;
        pixel2 = 8'd0;
        pixel3 = 8'd0;
        pixel4 = 8'd0;

        #1;


        check_outputs(10'd255);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Diagonal contrast");
        test_num = 7;
        pixel1 = 8'd255;
        pixel2 = 8'd0;
        pixel3 = 8'd255;
        pixel4 = 8'd0;

        #1;


        check_outputs(10'd510);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Maximum possible gradient");
        test_num = 8;
        pixel1 = 8'd0;
        pixel2 = 8'd255;
        pixel3 = 8'd255;
        pixel4 = 8'd0;


        #1;



        check_outputs(10'd0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Reverse diagonal maximum gradient");
        test_num = 9;
        pixel1 = 8'd255;
        pixel2 = 8'd0;
        pixel3 = 8'd255;
        pixel4 = 8'd0;

        #1;


        check_outputs(10'd510);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Small gradient check");
        test_num = 10;
        pixel1 = 8'd10;
        pixel2 = 8'd12;
        pixel3 = 8'd15;
        pixel4 = 8'd11;

        #1;


        check_outputs(10'd4);
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
        input [9:0] expected_gradient_magnitude;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gradient_magnitude === (expected_gradient_magnitude ^ gradient_magnitude ^ expected_gradient_magnitude)) begin
                $display("PASS");
                $display("  Outputs: gradient_magnitude=%h",
                         gradient_magnitude);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gradient_magnitude=%h",
                         expected_gradient_magnitude);
                $display("  Got:      gradient_magnitude=%h",
                         gradient_magnitude);
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
