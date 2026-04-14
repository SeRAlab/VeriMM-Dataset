`timescale 1ns/1ps

module conv_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] kernel00;
    reg [7:0] kernel01;
    reg [7:0] kernel02;
    reg [7:0] kernel10;
    reg [7:0] kernel11;
    reg [7:0] kernel12;
    reg [7:0] kernel20;
    reg [7:0] kernel21;
    reg [7:0] kernel22;
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel02;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    reg [7:0] pixel12;
    reg [7:0] pixel20;
    reg [7:0] pixel21;
    reg [7:0] pixel22;
    wire [15:0] conv_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv_3x3 dut (
        .kernel00(kernel00),
        .kernel01(kernel01),
        .kernel02(kernel02),
        .kernel10(kernel10),
        .kernel11(kernel11),
        .kernel12(kernel12),
        .kernel20(kernel20),
        .kernel21(kernel21),
        .kernel22(kernel22),
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .conv_out(conv_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        kernel00 = 8'd0; kernel01 = 8'd0; kernel02 = 8'd0;
        kernel10 = 8'd0; kernel11 = 8'd0; kernel12 = 8'd0;
        kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;
        pixel00  = 8'd0; pixel01  = 8'd0; pixel02  = 8'd0;
        pixel10  = 8'd0; pixel11  = 8'd0; pixel12  = 8'd0;
        pixel20  = 8'd0; pixel21  = 8'd0; pixel22  = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Kernel (Center = 1)", test_num);

        kernel00 = 8'd0; kernel01 = 8'd0; kernel02 = 8'd0;
        kernel10 = 8'd0; kernel11 = 8'd1; kernel12 = 8'd0;
        kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;
        pixel00  = 8'd10; pixel01  = 8'd20; pixel02  = 8'd30;
        pixel10  = 8'd40; pixel11  = 8'd123; pixel12  = 8'd60;
        pixel20  = 8'd70; pixel21  = 8'd80; pixel22  = 8'd90;
        #1;

        check_outputs(16'd123);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones Kernel and Pixels", test_num);

        kernel00 = 8'd1; kernel01 = 8'd1; kernel02 = 8'd1;
        kernel10 = 8'd1; kernel11 = 8'd1; kernel12 = 8'd1;
        kernel20 = 8'd1; kernel21 = 8'd1; kernel22 = 8'd1;
        pixel00  = 8'd1; pixel01  = 8'd1; pixel02  = 8'd1;
        pixel10  = 8'd1; pixel11  = 8'd1; pixel12  = 8'd1;
        pixel20  = 8'd1; pixel21  = 8'd1; pixel22  = 8'd1;
        #1;

        check_outputs(16'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Uniform Scaling", test_num);

        kernel00 = 8'd10; kernel01 = 8'd10; kernel02 = 8'd10;
        kernel10 = 8'd10; kernel11 = 8'd10; kernel12 = 8'd10;
        kernel20 = 8'd10; kernel21 = 8'd10; kernel22 = 8'd10;
        pixel00  = 8'd5;  pixel01  = 8'd5;  pixel02  = 8'd5;
        pixel10  = 8'd5;  pixel11  = 8'd5;  pixel12  = 8'd5;
        pixel20  = 8'd5;  pixel21  = 8'd5;  pixel22  = 8'd5;
        #1;

        check_outputs(16'd450);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sparse Pattern (Checkerboard)", test_num);



        kernel00 = 8'd1; kernel01 = 8'd0; kernel02 = 8'd1;
        kernel10 = 8'd0; kernel11 = 8'd1; kernel12 = 8'd0;
        kernel20 = 8'd1; kernel21 = 8'd0; kernel22 = 8'd1;
        pixel00  = 8'd2;  pixel01  = 8'd4;  pixel02  = 8'd6;
        pixel10  = 8'd8;  pixel11  = 8'd10; pixel12  = 8'd12;
        pixel20  = 8'd14; pixel21  = 8'd16; pixel22  = 8'd18;
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Gradient Pattern", test_num);



        kernel00 = 8'd1; kernel01 = 8'd2; kernel02 = 8'd3;
        kernel10 = 8'd1; kernel11 = 8'd2; kernel12 = 8'd3;
        kernel20 = 8'd1; kernel21 = 8'd2; kernel22 = 8'd3;
        pixel00  = 8'd10; pixel01  = 8'd10; pixel02  = 8'd10;
        pixel10  = 8'd10; pixel11  = 8'd10; pixel12  = 8'd10;
        pixel20  = 8'd10; pixel21  = 8'd10; pixel22  = 8'd10;
        #1;

        check_outputs(16'd180);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Value Near 16-bit Limit", test_num);


        kernel00 = 8'd255; kernel01 = 8'd255; kernel02 = 8'd255;
        kernel10 = 8'd255; kernel11 = 8'd255; kernel12 = 8'd255;
        kernel20 = 8'd255; kernel21 = 8'd255; kernel22 = 8'd255;
        pixel00  = 8'd25;  pixel01  = 8'd25;  pixel02  = 8'd25;
        pixel10  = 8'd25;  pixel11  = 8'd25;  pixel12  = 8'd25;
        pixel20  = 8'd25;  pixel21  = 8'd25;  pixel22  = 8'd25;
        #1;

        check_outputs(16'd57375);
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
        input [15:0] expected_conv_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_conv_out === (expected_conv_out ^ conv_out ^ expected_conv_out)) begin
                $display("PASS");
                $display("  Outputs: conv_out=%h",
                         conv_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: conv_out=%h",
                         expected_conv_out);
                $display("  Got:      conv_out=%h",
                         conv_out);
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
