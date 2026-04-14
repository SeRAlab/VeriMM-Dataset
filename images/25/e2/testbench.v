`timescale 1ns/1ps

module sobel_edge_detection_tb;

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
    wire [9:0] gradient_magnitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detection dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .gradient_magnitude(gradient_magnitude)
    );
    task testcase001;

        begin
            test_num = 1;
            pixel00 = 0; pixel01 = 0; pixel02 = 0;
            pixel10 = 0; pixel11 = 0; pixel12 = 0;
            pixel20 = 0; pixel21 = 0; pixel22 = 0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            pixel00 = 7; pixel01 = 7; pixel02 = 7;
            pixel10 = 7; pixel11 = 7; pixel12 = 7;
            pixel20 = 7; pixel21 = 7; pixel22 = 7;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            pixel00 = 0; pixel01 = 0; pixel02 = 7;
            pixel10 = 0; pixel11 = 0; pixel12 = 7;
            pixel20 = 0; pixel21 = 0; pixel22 = 7;
            #1;

            check_outputs(10'd28);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            pixel00 = 7; pixel01 = 7; pixel02 = 7;
            pixel10 = 0; pixel11 = 0; pixel12 = 0;
            pixel20 = 0; pixel21 = 0; pixel22 = 0;
            #1;

            check_outputs(10'd28);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            pixel00 = 7; pixel01 = 7; pixel02 = 0;
            pixel10 = 7; pixel11 = 0; pixel12 = 0;
            pixel20 = 0; pixel21 = 0; pixel22 = 0;
            #1;

            check_outputs(10'd42);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            pixel00 = 7; pixel01 = 0; pixel02 = 7;
            pixel10 = 0; pixel11 = 7; pixel12 = 0;
            pixel20 = 7; pixel21 = 0; pixel22 = 7;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            pixel00 = 0; pixel01 = 1; pixel02 = 2;
            pixel10 = 0; pixel11 = 1; pixel12 = 2;
            pixel20 = 0; pixel21 = 1; pixel22 = 3;




            #1;





            check_outputs(10'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sobel_edge_detection Testbench");
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
