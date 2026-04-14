`timescale 1ns/1ps

module dct_1d_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    reg [7:0] x4;
    reg [7:0] x5;
    reg [7:0] x6;
    reg [7:0] x7;
    wire [7:0] y0;
    wire [7:0] y1;
    wire [7:0] y2;
    wire [7:0] y3;
    wire [7:0] y4;
    wire [7:0] y5;
    wire [7:0] y6;
    wire [7:0] y7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dct_1d dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .x6(x6),
        .x7(x7),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .y5(y5),
        .y6(y6),
        .y7(y7)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros - Testing zero input response", test_num);
            x0 = 8'h00; x1 = 8'h00; x2 = 8'h00; x3 = 8'h00;
            x4 = 8'h00; x5 = 8'h00; x6 = 8'h00; x7 = 8'h00;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Constant DC - Testing pure DC component", test_num);
            x0 = 8'd64; x1 = 8'd64; x2 = 8'd64; x3 = 8'd64;
            x4 = 8'd64; x5 = 8'd64; x6 = 8'd64; x7 = 8'd64;




            #1;





            check_outputs(8'hB5, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Frequency - Testing alternating pattern", test_num);
            x0 = 8'd100; x1 = 8'd0; x2 = 8'd100; x3 = 8'd0;
            x4 = 8'd100; x5 = 8'd0; x6 = 8'd100; x7 = 8'd0;



            #1;




            check_outputs(8'h8D, 8'h00, 8'h00, 8'h00, 8'h80, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse Input - Testing distribution across frequencies", test_num);
            x0 = 8'd128; x1 = 8'd0; x2 = 8'd0; x3 = 8'd0;
            x4 = 8'd0;   x5 = 8'd0; x6 = 8'd0; x7 = 8'd0;




            #1;





            check_outputs(8'h2D, 8'h3F, 8'h3B, 8'h35, 8'h2D, 8'h23, 8'h18, 8'h0C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ramp Input - Testing mixed frequencies", test_num);
            x0 = 8'd10; x1 = 8'd20; x2 = 8'd30; x3 = 8'd40;
            x4 = 8'd50; x5 = 8'd60; x6 = 8'd70; x7 = 8'd80;


            #1;



            check_outputs(8'h7F, 8'hCD, 8'h00, 8'hF9, 8'h00, 8'hFE, 8'h00, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Symmetrical Pattern", test_num);
            x0 = 8'd50; x1 = 8'd100; x2 = 8'd150; x3 = 8'd200;
            x4 = 8'd200; x5 = 8'd150; x6 = 8'd100; x7 = 8'd50;

            #1;


            check_outputs(8'hE1, 8'h00, 8'hAF, 8'h00, 8'h14, 8'h00, 8'h0B, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dct_1d Testbench");
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
        input [7:0] expected_y0;
        input [7:0] expected_y1;
        input [7:0] expected_y2;
        input [7:0] expected_y3;
        input [7:0] expected_y4;
        input [7:0] expected_y5;
        input [7:0] expected_y6;
        input [7:0] expected_y7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3) &&
                expected_y4 === (expected_y4 ^ y4 ^ expected_y4) &&
                expected_y5 === (expected_y5 ^ y5 ^ expected_y5) &&
                expected_y6 === (expected_y6 ^ y6 ^ expected_y6) &&
                expected_y7 === (expected_y7 ^ y7 ^ expected_y7)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h, y2=%h, y3=%h, y4=%h, y5=%h, y6=%h, y7=%h",
                         y0, y1, y2, y3, y4, y5, y6, y7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h, y2=%h, y3=%h, y4=%h, y5=%h, y6=%h, y7=%h",
                         expected_y0, expected_y1, expected_y2, expected_y3, expected_y4, expected_y5, expected_y6, expected_y7);
                $display("  Got:      y0=%h, y1=%h, y2=%h, y3=%h, y4=%h, y5=%h, y6=%h, y7=%h",
                         y0, y1, y2, y3, y4, y5, y6, y7);
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
