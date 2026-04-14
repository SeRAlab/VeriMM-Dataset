`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixel0;
    reg [8:0] pixel1;
    reg [8:0] pixel2;
    reg [8:0] pixel3;
    reg [8:0] pixel4;
    reg [8:0] pixel5;
    reg [8:0] pixel6;
    reg [8:0] pixel7;
    reg [8:0] pixel8;
    wire [8:0] blurred_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .pixel0(pixel0),
        .pixel1(pixel1),
        .pixel2(pixel2),
        .pixel3(pixel3),
        .pixel4(pixel4),
        .pixel5(pixel5),
        .pixel6(pixel6),
        .pixel7(pixel7),
        .pixel8(pixel8),
        .blurred_pixel(blurred_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            pixel0 = 9'd0; pixel1 = 9'd0; pixel2 = 9'd0;
            pixel3 = 9'd0; pixel4 = 9'd0; pixel5 = 9'd0;
            pixel6 = 9'd0; pixel7 = 9'd0; pixel8 = 9'd0;

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            pixel0 = 9'd100; pixel1 = 9'd100; pixel2 = 9'd100;
            pixel3 = 9'd100; pixel4 = 9'd100; pixel5 = 9'd100;
            pixel6 = 9'd100; pixel7 = 9'd100; pixel8 = 9'd100;

            #1;


            check_outputs(9'd99);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            pixel0 = 9'd511; pixel1 = 9'd511; pixel2 = 9'd511;
            pixel3 = 9'd511; pixel4 = 9'd511; pixel5 = 9'd511;
            pixel6 = 9'd511; pixel7 = 9'd511; pixel8 = 9'd511;

            #1;


            check_outputs(9'd505);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            pixel0 = 9'd10; pixel1 = 9'd20; pixel2 = 9'd30;
            pixel3 = 9'd40; pixel4 = 9'd50; pixel5 = 9'd60;
            pixel6 = 9'd70; pixel7 = 9'd80; pixel8 = 9'd90;


            #1;



            check_outputs(9'd49);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            pixel0 = 9'd0;   pixel1 = 9'd0;   pixel2 = 9'd0;
            pixel3 = 9'd0;   pixel4 = 9'd200; pixel5 = 9'd0;
            pixel6 = 9'd0;   pixel7 = 9'd0;   pixel8 = 9'd0;

            #1;


            check_outputs(9'd22);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            pixel0 = 9'd9;   pixel1 = 9'd0;   pixel2 = 9'd0;
            pixel3 = 9'd0;   pixel4 = 9'd0;   pixel5 = 9'd0;
            pixel6 = 9'd0;   pixel7 = 9'd0;   pixel8 = 9'd0;

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            pixel0 = 9'd10;  pixel1 = 9'd0;   pixel2 = 9'd0;
            pixel3 = 9'd0;   pixel4 = 9'd0;   pixel5 = 9'd0;
            pixel6 = 9'd0;   pixel7 = 9'd0;   pixel8 = 9'd0;

            #1;


            check_outputs(9'd1);
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
        input [8:0] expected_blurred_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_blurred_pixel === (expected_blurred_pixel ^ blurred_pixel ^ expected_blurred_pixel)) begin
                $display("PASS");
                $display("  Outputs: blurred_pixel=%h",
                         blurred_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blurred_pixel=%h",
                         expected_blurred_pixel);
                $display("  Got:      blurred_pixel=%h",
                         blurred_pixel);
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
