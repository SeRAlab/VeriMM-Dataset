`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] l11;
    wire [3:0] l21;
    wire [3:0] u11;
    wire [3:0] u12;
    wire [3:0] u22;

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
            $display("Test Case %0d: Unit Matrix Scale", test_num);
            a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd8;

            #1;


            check_outputs(4'd1, 4'd3, 4'd1, 4'd2, 4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Even Values", test_num);
            a = 4'd2; b = 4'd2; c = 4'd4; d = 4'd10;

            #1;


            check_outputs(4'd1, 4'd2, 4'd2, 4'd2, 4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Larger first row", test_num);
            a = 4'd4; b = 4'd2; c = 4'd8; d = 4'd12;

            #1;


            check_outputs(4'd1, 4'd2, 4'd4, 4'd2, 4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Integer Division (7/2=3)", test_num);
            a = 4'd2; b = 4'd2; c = 4'd7; d = 4'd15;

            #1;


            check_outputs(4'd1, 4'd3, 4'd2, 4'd2, 4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: High boundary values", test_num);
            a = 4'd5; b = 4'd3; c = 4'd5; d = 4'd15;

            #1;


            check_outputs(4'd1, 4'd1, 4'd5, 4'd3, 4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Zero element b", test_num);
            a = 4'd4; b = 4'd0; c = 4'd8; d = 4'd4;

            #1;


            check_outputs(4'd1, 4'd2, 4'd4, 4'd0, 4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Zero element c", test_num);
            a = 4'd4; b = 4'd4; c = 4'd0; d = 4'd4;

            #1;


            check_outputs(4'd1, 4'd0, 4'd4, 4'd4, 4'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Scaled Identity", test_num);
            a = 4'd5; b = 4'd0; c = 4'd0; d = 4'd5;

            #1;


            check_outputs(4'd1, 4'd0, 4'd5, 4'd0, 4'd5);
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
        input [3:0] expected_l11;
        input [3:0] expected_l21;
        input [3:0] expected_u11;
        input [3:0] expected_u12;
        input [3:0] expected_u22;
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
