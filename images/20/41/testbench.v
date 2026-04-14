`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire [1:0] l11;
    wire [1:0] l21;
    wire [1:0] u11;
    wire [1:0] u12;
    wire [1:0] u21;
    wire [1:0] u22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .a(a),
        .b(b),
        .l11(l11),
        .l21(l21),
        .u11(u11),
        .u12(u12),
        .u21(u21),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix [1 0; 0 1]", test_num);
            a = 2'b10;
            b = 2'b01;
            #1;

            check_outputs(2'b01, 2'b00, 2'b01, 2'b00, 2'b00, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Matrix [1 1; 1 1]", test_num);
            a = 2'b11;
            b = 2'b11;
            #1;

            check_outputs(2'b01, 2'b01, 2'b01, 2'b01, 2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Matrix [1 1; 1 0]", test_num);
            a = 2'b11;
            b = 2'b10;
            #1;

            check_outputs(2'b01, 2'b01, 2'b01, 2'b01, 2'b00, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Matrix [1 0; 1 1]", test_num);
            a = 2'b10;
            b = 2'b11;
            #1;

            check_outputs(2'b01, 2'b01, 2'b01, 2'b00, 2'b00, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Matrix [1 1; 0 1]", test_num);
            a = 2'b11;
            b = 2'b01;
            #1;

            check_outputs(2'b01, 2'b00, 2'b01, 2'b01, 2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Matrix [1 1; 0 0]", test_num);
            a = 2'b11;
            b = 2'b00;
            #1;

            check_outputs(2'b01, 2'b00, 2'b01, 2'b01, 2'b00, 2'b00);
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
        input [1:0] expected_l11;
        input [1:0] expected_l21;
        input [1:0] expected_u11;
        input [1:0] expected_u12;
        input [1:0] expected_u21;
        input [1:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u21 === (expected_u21 ^ u21 ^ expected_u21) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l21=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l21, u11, u12, u21, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l21=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         expected_l11, expected_l21, expected_u11, expected_u12, expected_u21, expected_u22);
                $display("  Got:      l11=%h, l21=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l21, u11, u12, u21, u22);
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
