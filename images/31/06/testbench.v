`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixel00;
    reg [8:0] pixel01;
    reg [8:0] pixel02;
    reg [8:0] pixel10;
    reg [8:0] pixel11;
    reg [8:0] pixel12;
    reg [8:0] pixel20;
    reg [8:0] pixel21;
    reg [8:0] pixel22;
    wire [8:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .output_pixel(output_pixel)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All Zeros", test_num);
        pixel00=0; pixel01=0; pixel02=0;
        pixel10=0; pixel11=0; pixel12=0;
        pixel20=0; pixel21=0; pixel22=0;

        #1;


        check_outputs(9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All Pixels 255", test_num);
        pixel00=255; pixel01=255; pixel02=255;
        pixel10=255; pixel11=255; pixel12=255;
        pixel20=255; pixel21=255; pixel22=255;


        #1;



        check_outputs(9'd250);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Center Impulse (100)", test_num);
        pixel00=0; pixel01=0; pixel02=0;
        pixel10=0; pixel11=100; pixel12=0;
        pixel20=0; pixel21=0; pixel22=0;


        #1;



        check_outputs(9'd24);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Corner Impulse (200)", test_num);
        pixel00=200; pixel01=0; pixel02=0;
        pixel10=0;   pixel11=0; pixel12=0;
        pixel20=0;   pixel21=0; pixel22=0;


        #1;



        check_outputs(9'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Edge Impulse (150)", test_num);
        pixel00=0; pixel01=150; pixel02=0;
        pixel10=0; pixel11=0;   pixel12=0;
        pixel20=0; pixel21=0;   pixel22=0;


        #1;



        check_outputs(9'd18);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Mixed Values", test_num);

        pixel00=100;
        pixel01=100;
        pixel11=200;
        pixel02=0; pixel10=0; pixel12=0;
        pixel20=0; pixel21=0; pixel22=0;


        #1;



        check_outputs(9'd67);
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
        input [8:0] expected_output_pixel;
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
