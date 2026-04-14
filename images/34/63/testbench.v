`timescale 1ns/1ps

module DCT_2x2_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    wire [7:0] dct_00;
    wire [7:0] dct_01;
    wire [7:0] dct_10;
    wire [7:0] dct_11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DCT_2x2 dut (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .dct_00(dct_00),
        .dct_01(dct_01),
        .dct_10(dct_10),
        .dct_11(dct_11)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        pixel_00 = 8'sd0;
        pixel_01 = 8'sd0;
        pixel_10 = 8'sd0;
        pixel_11 = 8'sd0;

        #1;


        check_outputs(8'sh00, 8'sh00, 8'sh00, 8'sh00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Uniform DC Component", test_num);

        pixel_00 = 8'sd20;
        pixel_01 = 8'sd20;
        pixel_10 = 8'sd20;
        pixel_11 = 8'sd20;
        #1;

        check_outputs(8'sh28, 8'sh00, 8'sh00, 8'sh00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Horizontal Gradient", test_num);


        pixel_00 = 8'sd30;
        pixel_01 = -8'sd30;
        pixel_10 = 8'sd30;
        pixel_11 = -8'sd30;
        #1;

        check_outputs(8'sh00, 8'sh3C, 8'sh00, 8'sh00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Vertical Gradient", test_num);


        pixel_00 = 8'sd40;
        pixel_01 = 8'sd40;
        pixel_10 = -8'sd40;
        pixel_11 = -8'sd40;
        #1;

        check_outputs(8'sh00, 8'sh00, 8'sh50, 8'sh00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Checkerboard Pattern", test_num);


        pixel_00 = 8'sd25;
        pixel_01 = -8'sd25;
        pixel_10 = -8'sd25;
        pixel_11 = 8'sd25;
        #1;

        check_outputs(8'sh00, 8'sh00, 8'sh00, 8'sh32);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Negative DC Component", test_num);

        pixel_00 = -8'sd10;
        pixel_01 = -8'sd10;
        pixel_10 = -8'sd10;
        pixel_11 = -8'sd10;
        #1;

        check_outputs(8'shEC, 8'sh00, 8'sh00, 8'sh00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Mixed Input Values", test_num);





        pixel_00 = 8'sd10;
        pixel_01 = 8'sd20;
        pixel_10 = 8'sd30;
        pixel_11 = 8'sd40;
        #1;

        check_outputs(8'sh32, 8'shF6, 8'shEC, 8'sh00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: High Amplitude Signal", test_num);



        pixel_00 = 8'sd60;
        pixel_01 = 8'sd60;
        pixel_10 = 8'sd7;
        pixel_11 = 8'sd0;
        #1;

        check_outputs(8'sh3F, 8'sh03, 8'sh3F, 8'sh03);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DCT_2x2 Testbench");
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
        input [7:0] expected_dct_00;
        input [7:0] expected_dct_01;
        input [7:0] expected_dct_10;
        input [7:0] expected_dct_11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dct_00 === (expected_dct_00 ^ dct_00 ^ expected_dct_00) &&
                expected_dct_01 === (expected_dct_01 ^ dct_01 ^ expected_dct_01) &&
                expected_dct_10 === (expected_dct_10 ^ dct_10 ^ expected_dct_10) &&
                expected_dct_11 === (expected_dct_11 ^ dct_11 ^ expected_dct_11)) begin
                $display("PASS");
                $display("  Outputs: dct_00=%h, dct_01=%h, dct_10=%h, dct_11=%h",
                         dct_00, dct_01, dct_10, dct_11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dct_00=%h, dct_01=%h, dct_10=%h, dct_11=%h",
                         expected_dct_00, expected_dct_01, expected_dct_10, expected_dct_11);
                $display("  Got:      dct_00=%h, dct_01=%h, dct_10=%h, dct_11=%h",
                         dct_00, dct_01, dct_10, dct_11);
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
