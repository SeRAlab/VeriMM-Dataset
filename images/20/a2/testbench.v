`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] im0;
    reg [7:0] im1;
    reg [7:0] im2;
    reg [7:0] im3;
    reg [7:0] re0;
    reg [7:0] re1;
    reg [7:0] re2;
    reg [7:0] re3;
    wire [7:0] out_im0;
    wire [7:0] out_im1;
    wire [7:0] out_im2;
    wire [7:0] out_im3;
    wire [7:0] out_re0;
    wire [7:0] out_re1;
    wire [7:0] out_re2;
    wire [7:0] out_re3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .im0(im0),
        .im1(im1),
        .im2(im2),
        .im3(im3),
        .re0(re0),
        .re1(re1),
        .re2(re2),
        .re3(re3),
        .out_im0(out_im0),
        .out_im1(out_im1),
        .out_im2(out_im2),
        .out_im3(out_im3),
        .out_re0(out_re0),
        .out_re1(out_re1),
        .out_re2(out_re2),
        .out_re3(out_re3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Impulse at x0", test_num);
        re0 = 8'h01; im0 = 8'h00;
        re1 = 8'h00; im1 = 8'h00;
        re2 = 8'h00; im2 = 8'h00;
        re3 = 8'h00; im3 = 8'h00;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h01, 8'h01, 8'h01, 8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: DC Signal", test_num);
        re0 = 8'h01; im0 = 8'h00;
        re1 = 8'h01; im1 = 8'h00;
        re2 = 8'h01; im2 = 8'h00;
        re3 = 8'h01; im3 = 8'h00;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Nyquist Frequency", test_num);
        re0 = 8'h01; im0 = 8'h00;
        re1 = 8'hFF; im1 = 8'h00;
        re2 = 8'h01; im2 = 8'h00;
        re3 = 8'hFF; im3 = 8'h00;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Complex Exponential Bin 1", test_num);
        re0 = 8'h01; im0 = 8'h00;
        re1 = 8'h00; im1 = 8'h01;
        re2 = 8'hFF; im2 = 8'h00;
        re3 = 8'h00; im3 = 8'hFF;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Complex Exponential Bin 3", test_num);
        re0 = 8'h01; im0 = 8'h00;
        re1 = 8'h00; im1 = 8'hFF;
        re2 = 8'hFF; im2 = 8'h00;
        re3 = 8'h00; im3 = 8'h01;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Zeros Input", test_num);
        re0 = 0; im0 = 0; re1 = 0; im1 = 0;
        re2 = 0; im2 = 0; re3 = 0; im3 = 0;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Signed Ramp", test_num);
        re0 = 8'd10; re1 = 8'd20; re2 = 8'd30; re3 = 8'd40;
        im0 = 0; im1 = 0; im2 = 0; im3 = 0;
        #1;

        check_outputs(8'h00, 8'h14, 8'h00, 8'hEC, 8'h64, 8'hEC, 8'hEC, 8'hEC);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Wrap-around Check", test_num);
        re0 = 8'd60; re1 = 8'd60; re2 = 8'd60; re3 = 8'd60;
        im0 = 0; im1 = 0; im2 = 0; im3 = 0;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'hF0, 8'h00, 8'h00, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4point Testbench");
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
        input [7:0] expected_out_im0;
        input [7:0] expected_out_im1;
        input [7:0] expected_out_im2;
        input [7:0] expected_out_im3;
        input [7:0] expected_out_re0;
        input [7:0] expected_out_re1;
        input [7:0] expected_out_re2;
        input [7:0] expected_out_re3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_im0 === (expected_out_im0 ^ out_im0 ^ expected_out_im0) &&
                expected_out_im1 === (expected_out_im1 ^ out_im1 ^ expected_out_im1) &&
                expected_out_im2 === (expected_out_im2 ^ out_im2 ^ expected_out_im2) &&
                expected_out_im3 === (expected_out_im3 ^ out_im3 ^ expected_out_im3) &&
                expected_out_re0 === (expected_out_re0 ^ out_re0 ^ expected_out_re0) &&
                expected_out_re1 === (expected_out_re1 ^ out_re1 ^ expected_out_re1) &&
                expected_out_re2 === (expected_out_re2 ^ out_re2 ^ expected_out_re2) &&
                expected_out_re3 === (expected_out_re3 ^ out_re3 ^ expected_out_re3)) begin
                $display("PASS");
                $display("  Outputs: out_im0=%h, out_im1=%h, out_im2=%h, out_im3=%h, out_re0=%h, out_re1=%h, out_re2=%h, out_re3=%h",
                         out_im0, out_im1, out_im2, out_im3, out_re0, out_re1, out_re2, out_re3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_im0=%h, out_im1=%h, out_im2=%h, out_im3=%h, out_re0=%h, out_re1=%h, out_re2=%h, out_re3=%h",
                         expected_out_im0, expected_out_im1, expected_out_im2, expected_out_im3, expected_out_re0, expected_out_re1, expected_out_re2, expected_out_re3);
                $display("  Got:      out_im0=%h, out_im1=%h, out_im2=%h, out_im3=%h, out_re0=%h, out_re1=%h, out_re2=%h, out_re3=%h",
                         out_im0, out_im1, out_im2, out_im3, out_re0, out_re1, out_re2, out_re3);
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
