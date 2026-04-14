`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a11;
    reg [7:0] a12;
    reg [7:0] a21;
    reg [7:0] a22;
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
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .l21(l21),
        .u11(u11),
        .u12(u12),
        .u22(u22)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Scaled Identity Matrix", test_num);
        a11 = 8'h02; a12 = 8'h00; a21 = 8'h00; a22 = 8'h02;
        #1;

        check_outputs(8'h00, 8'h02, 8'h00, 8'h02);
    end

task






    task testcase002;
    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Integer LU", test_num);
        a11 = 8'h01; a12 = 8'h02; a21 = 8'h03; a22 = 8'h0A;
        #1;

        check_outputs(8'h03, 8'h01, 8'h02, 8'h04);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Truncated Division LU", test_num);
        a11 = 8'h04; a12 = 8'h08; a21 = 8'h0E; a22 = 8'h23;
        #1;

        check_outputs(8'h03, 8'h04, 8'h08, 8'h0B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: l21 becomes Zero", test_num);
        a11 = 8'h0A; a12 = 8'h05; a21 = 8'h03; a22 = 8'h14;
        #1;

        check_outputs(8'h00, 8'h0A, 8'h05, 8'h14);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Large Values", test_num);
        a11 = 8'h05; a12 = 8'h0A; a21 = 8'h19; a22 = 8'h3C;
        #1;

        check_outputs(8'h05, 8'h05, 8'h0A, 8'h0A);
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
