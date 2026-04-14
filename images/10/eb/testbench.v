`timescale 1ns/1ps

module conv_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] filter;
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel02;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    reg [7:0] pixel12;
    reg [7:0] pixel20;
    reg [7:0] pixel21;
    reg [7:0] pixel22;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv_3x3 dut (
        .filter(filter),
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            filter = 8'd0;
            pixel00 = 8'd0; pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0; pixel11 = 8'd0; pixel12 = 8'd0;
            pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unit pixels with unit filter", test_num);
            filter = 8'd1;
            pixel00 = 8'd1; pixel01 = 8'd1; pixel02 = 8'd1;
            pixel10 = 8'd1; pixel11 = 8'd1; pixel12 = 8'd1;
            pixel20 = 8'd1; pixel21 = 8'd1; pixel22 = 8'd1;

            #1;


            check_outputs(16'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single pixel with filter weight", test_num);
            filter = 8'd10;
            pixel00 = 8'd0;  pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0;  pixel11 = 8'd5; pixel12 = 8'd0;
            pixel20 = 8'd0;  pixel21 = 8'd0; pixel22 = 8'd0;

            #1;


            check_outputs(16'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gradient pixels with scalar filter", test_num);
            filter = 8'd2;
            pixel00 = 8'd1; pixel01 = 8'd2; pixel02 = 8'd3;
            pixel10 = 8'd4; pixel11 = 8'd5; pixel12 = 8'd6;
            pixel20 = 8'd7; pixel21 = 8'd8; pixel22 = 8'd9;

            #1;


            check_outputs(16'd90);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max filter with unit pixels", test_num);
            filter = 8'd255;
            pixel00 = 8'd1; pixel01 = 8'd1; pixel02 = 8'd1;
            pixel10 = 8'd1; pixel11 = 8'd1; pixel12 = 8'd1;
            pixel20 = 8'd1; pixel21 = 8'd1; pixel22 = 8'd1;

            #1;


            check_outputs(16'd2295);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large pixel values with filter", test_num);
            filter = 8'd50;
            pixel00 = 8'd100; pixel01 = 8'd100; pixel02 = 8'd100;
            pixel10 = 8'd100; pixel11 = 8'd100; pixel12 = 8'd100;
            pixel20 = 8'd100; pixel21 = 8'd100; pixel22 = 8'd100;

            #1;


            check_outputs(16'd45000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero filter with max pixels", test_num);
            filter = 8'd0;
            pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Handling potential 16-bit overflow (Wrapping)", test_num);
            filter = 8'd255;
            pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;


            #1;



            check_outputs(16'hEE09);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv_3x3 Testbench");
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
