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
    wire [7:0] edge_intensity;

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
        .edge_intensity(edge_intensity)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zero Pixels", test_num);
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
        $display("Testcase %0d: Uniform Grayscale (No Edges)", test_num);
        pixel00 = 8'h80; pixel01 = 8'h80; pixel02 = 8'h80;
        pixel10 = 8'h80; pixel11 = 8'h80; pixel12 = 8'h80;
        pixel20 = 8'h80; pixel21 = 8'h80; pixel22 = 8'h80;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Vertical Edge", test_num);
        pixel00 = 8'h00; pixel01 = 8'hFF; pixel02 = 8'hFF;
        pixel10 = 8'h00; pixel11 = 8'hFF; pixel12 = 8'hFF;
        pixel20 = 8'h00; pixel21 = 8'hFF; pixel22 = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Horizontal Edge", test_num);
        pixel00 = 8'h00; pixel01 = 8'h00; pixel02 = 8'h00;
        pixel10 = 8'hFF; pixel11 = 8'hFF; pixel12 = 8'hFF;
        pixel20 = 8'hFF; pixel21 = 8'hFF; pixel22 = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Diagonal Gradient", test_num);
        pixel00 = 8'd0;  pixel01 = 8'd0;  pixel02 = 8'd10;
        pixel10 = 8'd0;  pixel11 = 8'd10; pixel12 = 8'd20;
        pixel20 = 8'd10; pixel21 = 8'd20; pixel22 = 8'd30;
        #1;

        check_outputs(8'h8C);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtle Vertical Edge", test_num);
        pixel00 = 8'd50; pixel01 = 8'd50; pixel02 = 8'd100;
        pixel10 = 8'd50; pixel11 = 8'd50; pixel12 = 8'd100;
        pixel20 = 8'd50; pixel21 = 8'd50; pixel22 = 8'd100;
        #1;

        check_outputs(8'hC8);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checkerboard Pattern", test_num);
        pixel00 = 8'hFF; pixel01 = 8'h00; pixel02 = 8'hFF;
        pixel10 = 8'h00; pixel11 = 8'hFF; pixel12 = 8'h00;
        pixel20 = 8'hFF; pixel21 = 8'h00; pixel22 = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative Gradients", test_num);
        pixel00 = 8'd100; pixel01 = 8'd100; pixel02 = 8'd0;
        pixel10 = 8'd100; pixel11 = 8'd100; pixel12 = 8'd0;
        pixel20 = 8'd100; pixel21 = 8'd100; pixel22 = 8'd100;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_edge_intensity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_intensity === (expected_edge_intensity ^ edge_intensity ^ expected_edge_intensity)) begin
                $display("PASS");
                $display("  Outputs: edge_intensity=%h",
                         edge_intensity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_intensity=%h",
                         expected_edge_intensity);
                $display("  Got:      edge_intensity=%h",
                         edge_intensity);
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
