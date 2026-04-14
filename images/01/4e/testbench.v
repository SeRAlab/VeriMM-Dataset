`timescale 1ns/1ps

module non_maximum_supression_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] direction;
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_02;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    reg [7:0] pixel_12;
    reg [7:0] pixel_20;
    reg [7:0] pixel_21;
    reg [7:0] pixel_22;
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_maximum_supression dut (
        .direction(direction),
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_02(pixel_02),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_12(pixel_12),
        .pixel_20(pixel_20),
        .pixel_21(pixel_21),
        .pixel_22(pixel_22),
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Horizontal Direction, Center is local maximum", test_num);
            direction = 4'd0;
            pixel_00 = 8'h10; pixel_01 = 8'h10; pixel_02 = 8'h10;
            pixel_10 = 8'h50; pixel_11 = 8'hA0; pixel_12 = 8'h50;
            pixel_20 = 8'h10; pixel_21 = 8'h10; pixel_22 = 8'h10;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Horizontal Direction, Center NOT max (left neighbor higher)", test_num);
            direction = 4'd0;
            pixel_00 = 8'h10; pixel_01 = 8'h10; pixel_02 = 8'h10;
            pixel_10 = 8'hFF; pixel_11 = 8'hA0; pixel_12 = 8'h50;
            pixel_20 = 8'h10; pixel_21 = 8'h10; pixel_22 = 8'h10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 45-Deg Direction, Center is local maximum", test_num);
            direction = 4'd1;
            pixel_00 = 8'h10; pixel_01 = 8'h10; pixel_02 = 8'h40;
            pixel_10 = 8'h10; pixel_11 = 8'h88; pixel_12 = 8'h10;
            pixel_20 = 8'h40; pixel_21 = 8'h10; pixel_22 = 8'h10;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 45-Deg Direction, Center NOT max", test_num);
            direction = 4'd1;
            pixel_00 = 8'h10; pixel_01 = 8'h10; pixel_02 = 8'h40;
            pixel_10 = 8'h10; pixel_11 = 8'h88; pixel_12 = 8'h10;
            pixel_20 = 8'h90; pixel_21 = 8'h10; pixel_22 = 8'h10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Vertical Direction, Center is local maximum", test_num);
            direction = 4'd2;
            pixel_00 = 8'h00; pixel_01 = 8'h12; pixel_02 = 8'h00;
            pixel_10 = 8'h00; pixel_11 = 8'h77; pixel_12 = 8'h00;
            pixel_20 = 8'h00; pixel_21 = 8'h12; pixel_22 = 8'h00;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Vertical Direction, Center NOT max", test_num);
            direction = 4'd2;
            pixel_00 = 8'h00; pixel_01 = 8'h80; pixel_02 = 8'h00;
            pixel_10 = 8'h00; pixel_11 = 8'h77; pixel_12 = 8'h00;
            pixel_20 = 8'h00; pixel_21 = 8'h12; pixel_22 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 135-Deg Direction, Center is local maximum", test_num);
            direction = 4'd3;
            pixel_00 = 8'h20; pixel_01 = 8'h00; pixel_02 = 8'h00;
            pixel_10 = 8'h00; pixel_11 = 8'hCC; pixel_12 = 8'h00;
            pixel_20 = 8'h00; pixel_21 = 8'h00; pixel_22 = 8'h20;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 135-Deg Direction, Center NOT max", test_num);
            direction = 4'd3;
            pixel_00 = 8'h20; pixel_01 = 8'h00; pixel_02 = 8'h00;
            pixel_10 = 8'h00; pixel_11 = 8'hCC; pixel_12 = 8'h00;
            pixel_20 = 8'h00; pixel_21 = 8'h00; pixel_22 = 8'hCD;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Horizontal Direction, Equality case (all neighbors equal)", test_num);
            direction = 4'd0;
            pixel_00 = 8'h00; pixel_01 = 8'h00; pixel_02 = 8'h00;
            pixel_10 = 8'h55; pixel_11 = 8'h55; pixel_12 = 8'h55;
            pixel_20 = 8'h00; pixel_21 = 8'h00; pixel_22 = 8'h00;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero intensity case", test_num);
            direction = 4'd2;
            pixel_00 = 8'h00; pixel_01 = 8'h00; pixel_02 = 8'h00;
            pixel_10 = 8'h00; pixel_11 = 8'h00; pixel_12 = 8'h00;
            pixel_20 = 8'h00; pixel_21 = 8'h00; pixel_22 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("non_maximum_supression Testbench");
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
        input [7:0] expected_output_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_pixel === (expected_output_pixel ^ output_pixel ^ expected_output_pixel)) begin
                $display("PASS");
                $display("  Outputs: output_pixel=%h",
                         output_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_pixel=%h",
                         expected_output_pixel);
                $display("  Got:      output_pixel=%h",
                         output_pixel);
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
