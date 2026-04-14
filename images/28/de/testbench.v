`timescale 1ns/1ps

module matrix_multiply_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a00;
    reg [3:0] a01;
    reg [3:0] a10;
    reg [3:0] a11;
    reg [3:0] b00;
    reg [3:0] b01;
    reg [3:0] b10;
    reg [3:0] b11;
    wire [7:0] c00;
    wire [7:0] c01;
    wire [7:0] c10;
    wire [7:0] c11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_multiply dut (
        .a00(a00),
        .a01(a01),
        .a10(a10),
        .a11(a11),
        .b00(b00),
        .b01(b01),
        .b10(b10),
        .b11(b11),
        .c00(c00),
        .c01(c01),
        .c10(c10),
        .c11(c11)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix Multiplication", test_num);


            a00 = 4'd1; a01 = 4'd0;
            a10 = 4'd0; a11 = 4'd1;
            b00 = 4'd5; b01 = 4'd6;
            b10 = 4'd7; b11 = 4'd8;
            #1;

            check_outputs(8'd5, 8'd6, 8'd7, 8'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Matrix Multiplication", test_num);


            a00 = 4'd0; a01 = 4'd0;
            a10 = 4'd0; a11 = 4'd0;
            b00 = 4'd15; b01 = 4'd15;
            b10 = 4'd15; b11 = 4'd15;
            #1;

            check_outputs(8'd0, 8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Integer Multiplication", test_num);





            a00 = 4'd2; a01 = 4'd3;
            a10 = 4'd4; a11 = 4'd5;
            b00 = 4'd1; b01 = 4'd2;
            b10 = 4'd3; b11 = 4'd4;
            #1;

            check_outputs(8'd11, 8'd16, 8'd19, 8'd28);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Larger Values (within 8-bit range)", test_num);





            a00 = 4'd10; a01 = 4'd2;
            a10 = 4'd5;  a11 = 4'd8;
            b00 = 4'd12; b01 = 4'd3;
            b10 = 4'd4;  b11 = 4'd11;
            #1;

            check_outputs(8'd128, 8'd52, 8'd92, 8'd103);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Uniform Elements", test_num);


            a00 = 4'd3; a01 = 4'd3;
            a10 = 4'd3; a11 = 4'd3;
            b00 = 4'd3; b01 = 4'd3;
            b10 = 4'd3; b11 = 4'd3;
            #1;

            check_outputs(8'd18, 8'd18, 8'd18, 8'd18);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High-low Pattern", test_num);





            a00 = 4'd15; a01 = 4'd0;
            a10 = 4'd0;  a11 = 4'd15;
            b00 = 4'd0;  b01 = 4'd15;
            b10 = 4'd15; b11 = 4'd0;
            #1;

            check_outputs(8'd0, 8'd225, 8'd225, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_multiply Testbench");
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
        input [7:0] expected_c00;
        input [7:0] expected_c01;
        input [7:0] expected_c10;
        input [7:0] expected_c11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c00 === (expected_c00 ^ c00 ^ expected_c00) &&
                expected_c01 === (expected_c01 ^ c01 ^ expected_c01) &&
                expected_c10 === (expected_c10 ^ c10 ^ expected_c10) &&
                expected_c11 === (expected_c11 ^ c11 ^ expected_c11)) begin
                $display("PASS");
                $display("  Outputs: c00=%h, c01=%h, c10=%h, c11=%h",
                         c00, c01, c10, c11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c00=%h, c01=%h, c10=%h, c11=%h",
                         expected_c00, expected_c01, expected_c10, expected_c11);
                $display("  Got:      c00=%h, c01=%h, c10=%h, c11=%h",
                         c00, c01, c10, c11);
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
