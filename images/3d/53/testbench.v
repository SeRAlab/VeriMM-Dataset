`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a11;
    reg [15:0] a12;
    reg [15:0] a21;
    reg [15:0] a22;
    wire [15:0] l11;
    wire [15:0] l12;
    wire [15:0] l21;
    wire [15:0] l22;
    wire [15:0] u11;
    wire [15:0] u12;
    wire [15:0] u21;
    wire [15:0] u22;

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
        .l21(l21),
        .l22(l22),
        .u11(u11),
        .u12(u12),
        .u21(u21),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Identity Matrix", test_num);
            a11 = 16'h0001; a12 = 16'h0000;
            a21 = 16'h0000; a22 = 16'h0001;

            #1;


            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001, 16'h0001, 16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Integer Decomposition 1", test_num);
            a11 = 16'h0005; a12 = 16'h000A;
            a21 = 16'h000A; a22 = 16'h0019;


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0002, 16'h0001, 16'h0005, 16'h000A, 16'h0000, 16'h0005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Basic Integer Decomposition 2", test_num);
            a11 = 16'h0004; a12 = 16'h0008;
            a21 = 16'h000C; a22 = 16'h001E;


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001, 16'h0004, 16'h0008, 16'h0000, 16'h0006);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Small Values", test_num);
            a11 = 16'h0002; a12 = 16'h0002;
            a21 = 16'h0002; a22 = 16'h0004;


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0001, 16'h0001, 16'h0002, 16'h0002, 16'h0000, 16'h0002);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Larger Multiple Values", test_num);
            a11 = 16'h000A; a12 = 16'h0032;
            a21 = 16'h0014; a22 = 16'h006E;


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0002, 16'h0001, 16'h000A, 16'h0032, 16'h0000, 16'h000A);
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
        input [15:0] expected_l12;
        input [15:0] expected_l21;
        input [15:0] expected_l22;
        input [15:0] expected_u11;
        input [15:0] expected_u12;
        input [15:0] expected_u21;
        input [15:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l12 === (expected_l12 ^ l12 ^ expected_l12) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_l22 === (expected_l22 ^ l22 ^ expected_l22) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u21 === (expected_u21 ^ u21 ^ expected_u21) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l12, l21, l22, u11, u12, u21, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         expected_l11, expected_l12, expected_l21, expected_l22, expected_u11, expected_u12, expected_u21, expected_u22);
                $display("  Got:      l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l12, l21, l22, u11, u12, u21, u22);
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
