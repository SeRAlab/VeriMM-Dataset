`timescale 1ns/1ps

module lu_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    wire [31:0] l11;
    wire [31:0] l21;
    wire [31:0] u11;
    wire [31:0] u12;
    wire [31:0] u21;
    wire [31:0] u22;

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
        .u11(u11),
        .u12(u12),
        .u21(u21),
        .u22(u22)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Identity Matrix", test_num);
        a = 32'd1; b = 32'd0;
        c = 32'd0; d = 32'd1;
        #1;

        check_outputs(32'd1, 32'd0, 32'd1, 32'd0, 32'd0, 32'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simple Integer Matrix", test_num);
        a = 32'd2; b = 32'd2;
        c = 32'd4; d = 32'd6;
        #1;

        check_outputs(32'd1, 32'd2, 32'd2, 32'd2, 32'd0, 32'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Larger Integer Matrix", test_num);
        a = 32'd5; b = 32'd10;
        c = 32'd15; d = 32'd40;
        #1;

        check_outputs(32'd1, 32'd3, 32'd5, 32'd10, 32'd0, 32'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Negative Values in Matrix", test_num);
        a = 32'd2; b = -32'sd2;
        c = 32'd4; d = 32'd1;
        #1;

        check_outputs(32'd1, 32'd2, 32'd2, -32'sd2, 32'd0, 32'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Negative Values Resulting in Negative L", test_num);
        a = 32'd10; b = 32'd5;
        c = -32'sd20; d = 32'd10;
        #1;

        check_outputs(32'd1, -32'sd2, 32'd10, 32'd5, 32'd0, 32'd20);
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
        input [31:0] expected_l11;
        input [31:0] expected_l21;
        input [31:0] expected_u11;
        input [31:0] expected_u12;
        input [31:0] expected_u21;
        input [31:0] expected_u22;
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
