`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] l11;
    wire [7:0] l21;
    wire [7:0] u11;
    wire [7:0] u12;
    wire [7:0] u22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .l11(l11),
        .l21(l21),
        .u11(u11),
        .u12(u12),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = 1;

            a = 8'd1; b = 8'd2; c = 8'd3; d = 8'd10;

            #1;


            check_outputs(8'd1, 8'd3, 8'd1, 8'd2, 8'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            a = 8'd2; b = 8'd4; c = 8'd6; d = 8'd20;

            #1;


            check_outputs(8'd1, 8'd3, 8'd2, 8'd4, 8'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            a = 8'd4; b = 8'd1; c = 8'd8; d = 8'd5;

            #1;


            check_outputs(8'd1, 8'd2, 8'd4, 8'd1, 8'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            a = 8'd10; b = 8'd5; c = 8'd20; d = 8'd15;

            #1;


            check_outputs(8'd1, 8'd2, 8'd10, 8'd5, 8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            a = 8'd3; b = 8'd6; c = 8'd9; d = 8'd30;

            #1;


            check_outputs(8'd1, 8'd3, 8'd3, 8'd6, 8'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            a = 8'd5; b = 8'd10; c = 8'd0; d = 8'd7;

            #1;


            check_outputs(8'd1, 8'd0, 8'd5, 8'd10, 8'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            a = 8'd1; b = 8'd1; c = 8'd1; d = 8'd1;

            #1;


            check_outputs(8'd1, 8'd1, 8'd1, 8'd1, 8'd0);
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
        input [7:0] expected_l11;
        input [7:0] expected_l21;
        input [7:0] expected_u11;
        input [7:0] expected_u12;
        input [7:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l21=%h, u11=%h, u12=%h, u22=%h",
                         l11, l21, u11, u12, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l21=%h, u11=%h, u12=%h, u22=%h",
                         expected_l11, expected_l21, expected_u11, expected_u12, expected_u22);
                $display("  Got:      l11=%h, l21=%h, u11=%h, u12=%h, u22=%h",
                         l11, l21, u11, u12, u22);
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
