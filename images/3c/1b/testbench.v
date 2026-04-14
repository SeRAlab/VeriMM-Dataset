`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a11;
    reg [31:0] a12;
    reg [31:0] a21;
    reg [31:0] a22;
    wire [31:0] l11;
    wire [31:0] l21;
    wire [31:0] u11;
    wire [31:0] u12;
    wire [31:0] u22;

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
        .l21(l21),
        .u11(u11),
        .u12(u12),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Exact Division", test_num);


            a11 = 32'd2; a12 = 32'd4; a21 = 32'd6; a22 = 32'd20;





            #1;






            check_outputs(32'd2, 32'd3, 32'd2, 32'd4, 32'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Larger Factors", test_num);


            a11 = 32'd10; a12 = 32'd50; a21 = 32'd20; a22 = 32'd105;





            #1;






            check_outputs(32'd10, 32'd2, 32'd10, 32'd50, 32'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Integer Division (Truncation)", test_num);


            a11 = 32'd5; a12 = 32'd15; a21 = 32'd7; a22 = 32'd30;





            #1;






            check_outputs(32'd5, 32'd1, 32'd5, 32'd15, 32'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Result for u22", test_num);


            a11 = 32'd4; a12 = 32'd12; a21 = 32'd8; a22 = 32'd20;





            #1;






            check_outputs(32'd4, 32'd2, 32'd4, 32'd12, 32'hFFFFFFFC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimal Values", test_num);


            a11 = 32'd1; a12 = 32'd1; a21 = 32'd1; a22 = 32'd1;





            #1;






            check_outputs(32'd1, 32'd1, 32'd1, 32'd1, 32'd0);
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
        input [31:0] expected_l11;
        input [31:0] expected_l21;
        input [31:0] expected_u11;
        input [31:0] expected_u12;
        input [31:0] expected_u22;
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
