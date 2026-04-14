`timescale 1ns/1ps

module matrix_mult_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a11;
    reg [7:0] a12;
    reg [7:0] a21;
    reg [7:0] a22;
    reg [7:0] b11;
    reg [7:0] b12;
    reg [7:0] b21;
    reg [7:0] b22;
    wire [15:0] c11;
    wire [15:0] c12;
    wire [15:0] c21;
    wire [15:0] c22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_mult dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .b11(b11),
        .b12(b12),
        .b21(b21),
        .b22(b22),
        .c11(c11),
        .c12(c12),
        .c21(c21),
        .c22(c22)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Matrix (A=I, B=Value)", test_num);

        a11 = 0; a12 = 0; a21 = 0; a22 = 0;
        b11 = 0; b12 = 0; b21 = 0; b22 = 0;
        #10;

        a11 = 8'd1;  a12 = 8'd0;
        a21 = 8'd0;  a22 = 8'd1;
        b11 = 8'd10; b12 = 8'd20;
        b21 = 8'd30; b22 = 8'd40;

        #1;


        check_outputs(16'd10, 16'd20, 16'd30, 16'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Matrix (A=Value, B=0)", test_num);

        a11 = 0; a12 = 0; a21 = 0; a22 = 0;
        b11 = 0; b12 = 0; b21 = 0; b22 = 0;
        #10;

        a11 = 8'd5; a12 = 8'd5;
        a21 = 8'd5; a22 = 8'd5;
        b11 = 8'd0; b12 = 8'd0;
        b21 = 8'd0; b22 = 8'd0;

        #1;


        check_outputs(16'd0, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Integers", test_num);

        a11 = 0; a12 = 0; a21 = 0; a22 = 0;
        b11 = 0; b12 = 0; b21 = 0; b22 = 0;
        #10;





        a11 = 8'd1; a12 = 8'd2;
        a21 = 8'd3; a22 = 8'd4;
        b11 = 8'd5; b12 = 8'd6;
        b21 = 8'd7; b22 = 8'd8;
        #1;

        check_outputs(16'd19, 16'd22, 16'd43, 16'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Diagonal and Anti-Diagonal", test_num);

        a11 = 0; a12 = 0; a21 = 0; a22 = 0;
        b11 = 0; b12 = 0; b21 = 0; b22 = 0;
        #10;





        a11 = 8'd10; a12 = 8'd0;
        a21 = 8'd0;  a22 = 8'd10;
        b11 = 8'd0;  b12 = 8'd5;
        b21 = 8'd5;  b22 = 8'd0;
        #1;

        check_outputs(16'd0, 16'd50, 16'd50, 16'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Values (Within 16-bit range)", test_num);

        a11 = 0; a12 = 0; a21 = 0; a22 = 0;
        b11 = 0; b12 = 0; b21 = 0; b22 = 0;
        #10;


        a11 = 8'd100; a12 = 8'd100;
        a21 = 8'd100; a22 = 8'd100;
        b11 = 8'd50;  b12 = 8'd50;
        b21 = 8'd50;  b22 = 8'd50;
        #1;

        check_outputs(16'd10000, 16'd10000, 16'd10000, 16'd10000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 8-bit inputs (No Overflow)", test_num);

        a11 = 0; a12 = 0; a21 = 0; a22 = 0;
        b11 = 0; b12 = 0; b21 = 0; b22 = 0;
        #10;


        a11 = 8'hFF; a12 = 8'h00;
        a21 = 8'h00; a22 = 8'hFF;
        b11 = 8'hFF; b12 = 8'h00;
        b21 = 8'h00; b22 = 8'hFF;
        #1;

        check_outputs(16'hFE01, 16'h0000, 16'h0000, 16'hFE01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Values (16-bit Truncation Check)", test_num);

        a11 = 0; a12 = 0; a21 = 0; a22 = 0;
        b11 = 0; b12 = 0; b21 = 0; b22 = 0;
        #10;



        a11 = 8'd255; a12 = 8'd255;
        a21 = 8'd255; a22 = 8'd255;
        b11 = 8'd255; b12 = 8'd255;
        b21 = 8'd255; b22 = 8'd255;
        #1;

        check_outputs(16'hFC02, 16'hFC02, 16'hFC02, 16'hFC02);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_mult Testbench");
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
        input [15:0] expected_c11;
        input [15:0] expected_c12;
        input [15:0] expected_c21;
        input [15:0] expected_c22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c11 === (expected_c11 ^ c11 ^ expected_c11) &&
                expected_c12 === (expected_c12 ^ c12 ^ expected_c12) &&
                expected_c21 === (expected_c21 ^ c21 ^ expected_c21) &&
                expected_c22 === (expected_c22 ^ c22 ^ expected_c22)) begin
                $display("PASS");
                $display("  Outputs: c11=%h, c12=%h, c21=%h, c22=%h",
                         c11, c12, c21, c22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c11=%h, c12=%h, c21=%h, c22=%h",
                         expected_c11, expected_c12, expected_c21, expected_c22);
                $display("  Got:      c11=%h, c12=%h, c21=%h, c22=%h",
                         c11, c12, c21, c22);
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
