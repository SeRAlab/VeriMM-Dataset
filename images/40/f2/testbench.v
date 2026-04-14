`timescale 1ns/1ps

module sobel_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel02;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    reg [7:0] pixel12;
    reg [7:0] pixel20;
    reg [7:0] pixel21;
    reg [7:0] pixel22;
    wire [7:0] gradient;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_filter dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .gradient(gradient)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Flat region)", test_num);
            pixel00 = 8'h00; pixel01 = 8'h00; pixel02 = 8'h00;
            pixel10 = 8'h00; pixel11 = 8'h00; pixel12 = 8'h00;
            pixel20 = 8'h00; pixel21 = 8'h00; pixel22 = 8'h00;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All 255s (Flat region)", test_num);
            pixel00 = 8'hFF; pixel01 = 8'hFF; pixel02 = 8'hFF;
            pixel10 = 8'hFF; pixel11 = 8'hFF; pixel12 = 8'hFF;
            pixel20 = 8'hFF; pixel21 = 8'hFF; pixel22 = 8'hFF;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Strong Vertical Edge", test_num);
            pixel00 = 8'h00; pixel01 = 8'h00; pixel02 = 8'hFF;
            pixel10 = 8'h00; pixel11 = 8'h00; pixel12 = 8'hFF;
            pixel20 = 8'h00; pixel21 = 8'h00; pixel22 = 8'hFF;



            #1;




            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Strong Horizontal Edge", test_num);
            pixel00 = 8'hFF; pixel01 = 8'hFF; pixel02 = 8'hFF;
            pixel10 = 8'h00; pixel11 = 8'h00; pixel12 = 8'h00;
            pixel20 = 8'h00; pixel21 = 8'h00; pixel22 = 8'h00;



            #1;




            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtle Horizontal Gradient", test_num);
            pixel00 = 8'd10; pixel01 = 8'd20; pixel02 = 8'd10;
            pixel10 = 8'd10; pixel11 = 8'd20; pixel12 = 8'd10;
            pixel20 = 8'd00; pixel21 = 8'd00; pixel22 = 8'd00;



            #1;




            check_outputs(8'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtle Vertical Gradient", test_num);
            pixel00 = 8'd10; pixel01 = 8'd10; pixel02 = 8'd20;
            pixel10 = 8'd10; pixel11 = 8'd10; pixel12 = 8'd20;
            pixel20 = 8'd10; pixel21 = 8'd10; pixel22 = 8'd20;



            #1;




            check_outputs(8'd40);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Diagonal Edge", test_num);
            pixel00 = 8'd50; pixel01 = 8'd00; pixel02 = 8'd00;
            pixel10 = 8'd00; pixel11 = 8'd00; pixel12 = 8'd00;
            pixel20 = 8'd00; pixel21 = 8'd00; pixel22 = 8'd00;



            #1;




            check_outputs(8'd100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sobel_filter Testbench");
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
        input [7:0] expected_gradient;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gradient === (expected_gradient ^ gradient ^ expected_gradient)) begin
                $display("PASS");
                $display("  Outputs: gradient=%h",
                         gradient);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gradient=%h",
                         expected_gradient);
                $display("  Got:      gradient=%h",
                         gradient);
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
