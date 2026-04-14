`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a11;
    reg [7:0] a12;
    reg [7:0] a21;
    reg [7:0] a22;
    wire [7:0] l11;
    wire [7:0] l12;
    wire [7:0] u11;
    wire [7:0] u12;
    wire [7:0] u21;
    wire [7:0] u22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .l11(l11),
        .l12(l12),
        .u11(u11),
        .u12(u12),
        .u21(u21),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix", test_num);

            a11 = 8'h01; a12 = 8'h00;
            a21 = 8'h00; a22 = 8'h01;


            #1;



            check_outputs(8'h01, 8'h00, 8'h01, 8'h00, 8'h00, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Integer Matrix (a11=1)", test_num);


            a11 = 8'd1; a12 = 8'd2;
            a21 = 8'd3; a22 = 8'd10;

            #1;


            check_outputs(8'h01, 8'h00, 8'h01, 8'h02, 8'h00, 8'h04);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiples of a11", test_num);


            a11 = 8'd2; a12 = 8'd4;
            a21 = 8'd4; a22 = 8'd12;

            #1;


            check_outputs(8'h01, 8'h00, 8'h02, 8'h04, 8'h00, 8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large result subtraction", test_num);


            a11 = 8'd4; a12 = 8'd5;
            a21 = 8'd12; a22 = 8'd20;

            #1;


            check_outputs(8'h01, 8'h00, 8'h04, 8'h05, 8'h00, 8'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dependent rows (u22=0)", test_num);


            a11 = 8'd3; a12 = 8'd6;
            a21 = 8'd6; a22 = 8'd12;

            #1;


            check_outputs(8'h01, 8'h00, 8'h03, 8'h06, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Prime scaling", test_num);


            a11 = 8'd5; a12 = 8'd3;
            a21 = 8'd10; a22 = 8'd15;

            #1;


            check_outputs(8'h01, 8'h00, 8'h05, 8'h03, 8'h00, 8'h09);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_Decomposition Testbench");
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
        input [7:0] expected_l11;
        input [7:0] expected_l12;
        input [7:0] expected_u11;
        input [7:0] expected_u12;
        input [7:0] expected_u21;
        input [7:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l12 === (expected_l12 ^ l12 ^ expected_l12) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u21 === (expected_u21 ^ u21 ^ expected_u21) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l12=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l12, u11, u12, u21, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l12=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         expected_l11, expected_l12, expected_u11, expected_u12, expected_u21, expected_u22);
                $display("  Got:      l11=%h, l12=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l12, u11, u12, u21, u22);
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
