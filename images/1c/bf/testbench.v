`timescale 1ns/1ps

module gaussian_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] P1;
    reg [7:0] P2;
    reg [7:0] P3;
    reg [7:0] P4;
    reg [7:0] P5;
    reg [7:0] P6;
    reg [7:0] P7;
    reg [7:0] P8;
    reg [7:0] P9;
    wire [7:0] filtered_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_filter dut (
        .P1(P1),
        .P2(P2),
        .P3(P3),
        .P4(P4),
        .P5(P5),
        .P6(P6),
        .P7(P7),
        .P8(P8),
        .P9(P9),
        .filtered_pixel(filtered_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Darkness)", test_num);
            P1 = 8'h00; P2 = 8'h00; P3 = 8'h00;
            P4 = 8'h00; P5 = 8'h00; P6 = 8'h00;
            P7 = 8'h00; P8 = 8'h00; P9 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Max (White)", test_num);
            P1 = 8'hFF; P2 = 8'hFF; P3 = 8'hFF;
            P4 = 8'hFF; P5 = 8'hFF; P6 = 8'hFF;
            P7 = 8'hFF; P8 = 8'hFF; P9 = 8'hFF;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center Impulse", test_num);
            P1 = 8'h00; P2 = 8'h00; P3 = 8'h00;
            P4 = 8'h00; P5 = 8'hFF; P6 = 8'h00;
            P7 = 8'h00; P8 = 8'h00; P9 = 8'h00;

            #1;


            check_outputs(8'd63);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal Line (Middle)", test_num);
            P1 = 8'h00; P2 = 8'h00; P3 = 8'h00;
            P4 = 8'hFF; P5 = 8'hFF; P6 = 8'hFF;
            P7 = 8'h00; P8 = 8'h00; P9 = 8'h00;

            #1;


            check_outputs(8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Line (Middle)", test_num);
            P1 = 8'h00; P2 = 8'hFF; P3 = 8'h00;
            P4 = 8'h00; P5 = 8'hFF; P6 = 8'h00;
            P7 = 8'h00; P8 = 8'hFF; P9 = 8'h00;

            #1;


            check_outputs(8'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Smooth Gradient", test_num);
            P1 = 8'd10; P2 = 8'd20; P3 = 8'd30;
            P4 = 8'd40; P5 = 8'd50; P6 = 8'd60;
            P7 = 8'd70; P8 = 8'd80; P9 = 8'd90;


            #1;



            check_outputs(8'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Corners Only", test_num);
            P1 = 8'hFF; P2 = 8'h00; P3 = 8'hFF;
            P4 = 8'h00; P5 = 8'h00; P6 = 8'h00;
            P7 = 8'hFF; P8 = 8'h00; P9 = 8'hFF;

            #1;


            check_outputs(8'd63);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Value Check", test_num);
            P1 = 8'd1; P2 = 8'd1; P3 = 8'd1;
            P4 = 8'd1; P5 = 8'd1; P6 = 8'd1;
            P7 = 8'd1; P8 = 8'd1; P9 = 8'd1;

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-Gray Uniform", test_num);
            P1 = 8'd128; P2 = 8'd128; P3 = 8'd128;
            P4 = 8'd128; P5 = 8'd128; P6 = 8'd128;
            P7 = 8'd128; P8 = 8'd128; P9 = 8'd128;

            #1;


            check_outputs(8'd128);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern", test_num);
            P1 = 8'hFF; P2 = 8'h00; P3 = 8'hFF;
            P4 = 8'h00; P5 = 8'hFF; P6 = 8'h00;
            P7 = 8'hFF; P8 = 8'h00; P9 = 8'hFF;


            #1;



            check_outputs(8'd127);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gaussian_filter Testbench");
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
