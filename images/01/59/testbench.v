`timescale 1ns/1ps

module canny_edge_detector_tb;

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
    wire [7:0] edge_strength;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    canny_edge_detector dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .edge_strength(edge_strength)
    );
    task testcase001;

        begin
            test_num = 1;
            pixel00 = 8'd0; pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0; pixel11 = 8'd0; pixel12 = 8'd0;
            pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            pixel00 = 8'd128; pixel01 = 8'd128; pixel02 = 8'd128;
            pixel10 = 8'd128; pixel11 = 8'd128; pixel12 = 8'd128;
            pixel20 = 8'd128; pixel21 = 8'd128; pixel22 = 8'd128;


            #1;



            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            pixel00 = 8'd10; pixel01 = 8'd10; pixel02 = 8'd30;
            pixel10 = 8'd10; pixel11 = 8'd10; pixel12 = 8'd30;
            pixel20 = 8'd10; pixel21 = 8'd10; pixel22 = 8'd30;



            #1;




            check_outputs(8'd80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            pixel00 = 8'd50; pixel01 = 8'd50; pixel02 = 8'd50;
            pixel10 = 8'd30; pixel11 = 8'd30; pixel12 = 8'd30;
            pixel20 = 8'd10; pixel21 = 8'd10; pixel22 = 8'd10;



            #1;




            check_outputs(8'd160);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            pixel00 = 8'd0;   pixel01 = 8'd10;  pixel02 = 8'd20;
            pixel10 = 8'd10;  pixel11 = 8'd20;  pixel12 = 8'd30;
            pixel20 = 8'd20;  pixel21 = 8'd30;  pixel22 = 8'd40;



            #1;




            check_outputs(8'd80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0;   pixel22 = 8'd0;



            #1;




            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            pixel00 = 8'd100; pixel01 = 8'd0;   pixel02 = 8'd0;
            pixel10 = 8'd100; pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd100; pixel21 = 8'd0;   pixel22 = 8'd0;



            #1;




            check_outputs(8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            pixel00 = 8'd50;  pixel01 = 8'd50;  pixel02 = 8'd50;
            pixel10 = 8'd51;  pixel11 = 8'd51;  pixel12 = 8'd51;
            pixel20 = 8'd52;  pixel21 = 8'd52;  pixel22 = 8'd52;



            #1;




            check_outputs(8'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("canny_edge_detector Testbench");
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
        input [7:0] expected_edge_strength;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_strength === (expected_edge_strength ^ edge_strength ^ expected_edge_strength)) begin
                $display("PASS");
                $display("  Outputs: edge_strength=%h",
                         edge_strength);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_strength=%h",
                         expected_edge_strength);
                $display("  Got:      edge_strength=%h",
                         edge_strength);
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
