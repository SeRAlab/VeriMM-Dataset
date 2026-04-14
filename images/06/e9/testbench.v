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
            test_num = 1;
            $display("Test Case %0d: Identity Matrix (A * I = A)", test_num);

            a11 = 8'h05; a12 = 8'h0A;
            a21 = 8'h0F; a22 = 8'h14;

            b11 = 8'h01; b12 = 8'h00;
            b21 = 8'h00; b22 = 8'h01;


            #1;



            check_outputs(16'h0005, 16'h000A, 16'h000F, 16'h0014);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Zero Matrix (A * 0 = 0)", test_num);

            a11 = 8'hFF; a12 = 8'hFF;
            a21 = 8'hFF; a22 = 8'hFF;

            b11 = 8'h00; b12 = 8'h00;
            b21 = 8'h00; b22 = 8'h00;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Simple Multiplication", test_num);

            a11 = 8'd1; a12 = 8'd2;
            a21 = 8'd3; a22 = 8'd4;

            b11 = 8'd5; b12 = 8'd6;
            b21 = 8'd7; b22 = 8'd8;





            #1;






            check_outputs(16'h0013, 16'h0016, 16'h002B, 16'h0032);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Larger Values (No Overflow)", test_num);

            a11 = 8'd100; a12 = 8'd50;
            a21 = 8'd20;  a22 = 8'd10;

            b11 = 8'd10; b12 = 8'd20;
            b21 = 8'd30; b22 = 8'd40;





            #1;






            check_outputs(16'h09C4, 16'h0FA0, 16'h01F4, 16'h0320);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Single Element Interaction", test_num);

            a11 = 8'd1; a12 = 8'd0;
            a21 = 8'd0; a22 = 8'd0;

            b11 = 8'd0; b12 = 8'd0;
            b21 = 8'd1; b22 = 8'd0;





            #1;






            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Power of 2 Values", test_num);

            a11 = 8'd16; a12 = 8'd16;
            a21 = 8'd16; a22 = 8'd16;

            b11 = 8'd16; b12 = 8'd16;
            b21 = 8'd16; b22 = 8'd16;


            #1;



            check_outputs(16'h0200, 16'h0200, 16'h0200, 16'h0200);
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
