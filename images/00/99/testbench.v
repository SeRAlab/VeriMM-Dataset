`timescale 1ns/1ps

module gaussian_blur_tb;

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
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .P1(P1),
        .P2(P2),
        .P3(P3),
        .P4(P4),
        .P5(P5),
        .P6(P6),
        .P7(P7),
        .P8(P8),
        .P9(P9),
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase 001: All Zeros");
            P1 = 8'd0; P2 = 8'd0; P3 = 8'd0;
            P4 = 8'd0; P5 = 8'd0; P6 = 8'd0;
            P7 = 8'd0; P8 = 8'd0; P9 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: All Max (255)");
            P1 = 8'd255; P2 = 8'd255; P3 = 8'd255;
            P4 = 8'd255; P5 = 8'd255; P6 = 8'd255;
            P7 = 8'd255; P8 = 8'd255; P9 = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: Center Impulse (P5=255)");
            P1 = 8'd0; P2 = 8'd0; P3 = 8'd0;
            P4 = 8'd0; P5 = 8'd255; P6 = 8'd0;
            P7 = 8'd0; P8 = 8'd0; P9 = 8'd0;
            #1;

            check_outputs(8'd63);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: Corner Impulse (P1=255)");
            P1 = 8'd255; P2 = 8'd0; P3 = 8'd0;
            P4 = 8'd0;   P5 = 8'd0; P6 = 8'd0;
            P7 = 8'd0;   P8 = 8'd0; P9 = 8'd0;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase 005: Gradient Values");
            P1 = 8'd10; P2 = 8'd20; P3 = 8'd30;
            P4 = 8'd40; P5 = 8'd50; P6 = 8'd60;
            P7 = 8'd70; P8 = 8'd80; P9 = 8'd90;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nRunning Testcase 006: Vertical Line");
            P1 = 8'd0; P2 = 8'd255; P3 = 8'd0;
            P4 = 8'd0; P5 = 8'd255; P6 = 8'd0;
            P7 = 8'd0; P8 = 8'd255; P9 = 8'd0;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nRunning Testcase 007: Horizontal Line");
            P1 = 8'd0;   P2 = 8'd0;   P3 = 8'd0;
            P4 = 8'd255; P5 = 8'd255; P6 = 8'd255;
            P7 = 8'd0;   P8 = 8'd0;   P9 = 8'd0;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nRunning Testcase 008: Checkerboard Pattern");
            P1 = 8'd255; P2 = 8'd0;   P3 = 8'd255;
            P4 = 8'd0;   P5 = 8'd255; P6 = 8'd0;
            P7 = 8'd255; P8 = 8'd0;   P9 = 8'd255;
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
        $display("gaussian_blur Testbench");
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
