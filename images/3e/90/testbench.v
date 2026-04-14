`timescale 1ns/1ps

module lu_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    wire [15:0] l11;
    wire [15:0] l21;
    wire [15:0] l22;
    wire [15:0] u11;
    wire [15:0] u12;
    wire [15:0] u22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lu_decomposition dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .l11(l11),
        .l21(l21),
        .l22(l22),
        .u11(u11),
        .u12(u12),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple decomposition (Exact division)", test_num);

            a = 16'd2;
            b = 16'd4;
            c = 16'd6;
            d = 16'd15;







            #1;








            check_outputs(16'd1, 16'd3, 16'd3, 16'd2, 16'd4, 16'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Singular-like matrix (Zero results)", test_num);

            a = 16'd5;
            b = 16'd10;
            c = 16'd5;
            d = 16'd10;







            #1;








            check_outputs(16'd1, 16'd1, 16'd0, 16'd5, 16'd10, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Integer division truncation (c < a)", test_num);

            a = 16'd10;
            b = 16'd5;
            c = 16'd3;
            d = 16'd20;







            #1;








            check_outputs(16'd1, 16'd0, 16'd19, 16'd10, 16'd5, 16'd19);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Larger values (Safe within 16-bit)", test_num);

            a = 16'd100;
            b = 16'd50;
            c = 16'd200;
            d = 16'd400;







            #1;








            check_outputs(16'd1, 16'd2, 16'd300, 16'd100, 16'd50, 16'd300);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime numbers and truncation", test_num);

            a = 16'd7;
            b = 16'd3;
            c = 16'd15;
            d = 16'd11;







            #1;








            check_outputs(16'd1, 16'd2, 16'd5, 16'd7, 16'd3, 16'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum 'a' value", test_num);

            a = 16'd1;
            b = 16'd10;
            c = 16'd5;
            d = 16'd60;







            #1;








            check_outputs(16'd1, 16'd5, 16'd10, 16'd1, 16'd10, 16'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lu_decomposition Testbench");
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
        input [15:0] expected_l11;
        input [15:0] expected_l21;
        input [15:0] expected_l22;
        input [15:0] expected_u11;
        input [15:0] expected_u12;
        input [15:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_l22 === (expected_l22 ^ l22 ^ expected_l22) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l21=%h, l22=%h, u11=%h, u12=%h, u22=%h",
                         l11, l21, l22, u11, u12, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l21=%h, l22=%h, u11=%h, u12=%h, u22=%h",
                         expected_l11, expected_l21, expected_l22, expected_u11, expected_u12, expected_u22);
                $display("  Got:      l11=%h, l21=%h, l22=%h, u11=%h, u12=%h, u22=%h",
                         l11, l21, l22, u11, u12, u22);
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
