`timescale 1ns/1ps

module lu_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] l21;
    wire [7:0] u11;
    wire [7:0] u12;
    wire [7:0] u22;

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
        .l21(l21),
        .u11(u11),
        .u12(u12),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple decomposition", test_num);




            a = 8'd2; b = 8'd4; c = 8'd6; d = 8'd15;
            #1;

            check_outputs(8'd3, 8'd2, 8'd4, 8'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: u22 results in 6", test_num);




            a = 8'd5; b = 8'd2; c = 8'd10; d = 8'd16;
            #1;

            check_outputs(8'd2, 8'd5, 8'd2, 8'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=1 (l21 = c)", test_num);




            a = 8'd1; b = 8'd3; c = 8'd4; d = 8'd20;
            #1;

            check_outputs(8'd4, 8'd1, 8'd3, 8'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Integer division (c < a)", test_num);




            a = 8'd10; b = 8'd5; c = 8'd5; d = 8'd15;
            #1;

            check_outputs(8'd0, 8'd10, 8'd5, 8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero in b (u12)", test_num);




            a = 8'd8; b = 8'd0; c = 8'd16; d = 8'd3;
            #1;

            check_outputs(8'd2, 8'd8, 8'd0, 8'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: u22 becomes zero", test_num);



            a = 8'd2; b = 8'd2; c = 8'd2; d = 8'd2;
            #1;

            check_outputs(8'd1, 8'd2, 8'd2, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Larger values", test_num);



            a = 8'd12; b = 8'd4; c = 8'd36; d = 8'd20;
            #1;

            check_outputs(8'd3, 8'd12, 8'd4, 8'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max range checks", test_num);



            a = 8'd50; b = 8'd10; c = 8'd100; d = 8'd25;
            #1;

            check_outputs(8'd2, 8'd50, 8'd10, 8'd5);
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
        input [7:0] expected_l21;
        input [7:0] expected_u11;
        input [7:0] expected_u12;
        input [7:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l21=%h, u11=%h, u12=%h, u22=%h",
                         l21, u11, u12, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l21=%h, u11=%h, u12=%h, u22=%h",
                         expected_l21, expected_u11, expected_u12, expected_u22);
                $display("  Got:      l21=%h, u11=%h, u12=%h, u22=%h",
                         l21, u11, u12, u22);
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
