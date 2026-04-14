`timescale 1ns/1ps

module dct_2x2_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel0;
    reg [7:0] pixel1;
    reg [7:0] pixel2;
    reg [7:0] pixel3;
    wire [15:0] dct0;
    wire [15:0] dct1;
    wire [15:0] dct2;
    wire [15:0] dct3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dct_2x2 dut (
        .pixel0(pixel0),
        .pixel1(pixel1),
        .pixel2(pixel2),
        .pixel3(pixel3),
        .dct0(dct0),
        .dct1(dct1),
        .dct2(dct2),
        .dct3(dct3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Uniform Pixels (128)", test_num);
        pixel0 = 8'd128; pixel1 = 8'd128; pixel2 = 8'd128; pixel3 = 8'd128;




        #1;





        check_outputs(16'd512, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Vertical Bars (High Horizontal Freq)", test_num);
        pixel0 = 8'd200; pixel1 = 8'd0; pixel2 = 8'd200; pixel3 = 8'd0;




        #1;





        check_outputs(16'd400, 16'd400, 16'd0, 16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Horizontal Bars (High Vertical Freq)", test_num);
        pixel0 = 8'd255; pixel1 = 8'd255; pixel2 = 8'd0; pixel3 = 8'd0;




        #1;





        check_outputs(16'd510, 16'd0, 16'd510, 16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checkerboard (High Diagonal Freq)", test_num);
        pixel0 = 8'd255; pixel1 = 8'd0; pixel2 = 8'd0; pixel3 = 8'd255;




        #1;





        check_outputs(16'd510, 16'd0, 16'd0, 16'd510);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All Zeros", test_num);
        pixel0 = 8'd0; pixel1 = 8'd0; pixel2 = 8'd0; pixel3 = 8'd0;
        #1;

        check_outputs(16'd0, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All Max (255)", test_num);
        pixel0 = 8'd255; pixel1 = 8'd255; pixel2 = 8'd255; pixel3 = 8'd255;

        #1;


        check_outputs(16'd1020, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mixed Gradient", test_num);
        pixel0 = 8'd10; pixel1 = 8'd50; pixel2 = 8'd100; pixel3 = 8'd200;




        #1;





        check_outputs(16'd360, -16'd140, -16'd240, 16'd60);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Inverse Checkerboard", test_num);
        pixel0 = 8'd0; pixel1 = 8'd100; pixel2 = 8'd100; pixel3 = 8'd0;




        #1;





        check_outputs(16'd200, 16'd0, 16'd0, -16'd200);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dct_2x2 Testbench");
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
        input [15:0] expected_dct0;
        input [15:0] expected_dct1;
        input [15:0] expected_dct2;
        input [15:0] expected_dct3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dct0 === (expected_dct0 ^ dct0 ^ expected_dct0) &&
                expected_dct1 === (expected_dct1 ^ dct1 ^ expected_dct1) &&
                expected_dct2 === (expected_dct2 ^ dct2 ^ expected_dct2) &&
                expected_dct3 === (expected_dct3 ^ dct3 ^ expected_dct3)) begin
                $display("PASS");
                $display("  Outputs: dct0=%h, dct1=%h, dct2=%h, dct3=%h",
                         dct0, dct1, dct2, dct3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dct0=%h, dct1=%h, dct2=%h, dct3=%h",
                         expected_dct0, expected_dct1, expected_dct2, expected_dct3);
                $display("  Got:      dct0=%h, dct1=%h, dct2=%h, dct3=%h",
                         dct0, dct1, dct2, dct3);
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
