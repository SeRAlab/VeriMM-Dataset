`timescale 1ns/1ps

module qr_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] q1;
    wire [7:0] q2;
    wire [7:0] r11;
    wire [7:0] r12;
    wire [7:0] r21;
    wire [7:0] r22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qr_decomposition dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .q1(q1),
        .q2(q2),
        .r11(r11),
        .r12(r12),
        .r21(r21),
        .r22(r22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Matrix", test_num);
            a = 8'h01; b = 8'h00;
            c = 8'h00; d = 8'h01;

            #1;


            check_outputs(8'h01, 8'h00, 8'h01, 8'h00, 8'h00, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Scaled Identity Matrix", test_num);
            a = 8'd10; b = 8'd0;
            c = 8'd0;  d = 8'd10;

            #1;


            check_outputs(8'h01, 8'h00, 8'd10, 8'd0, 8'd0, 8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper Triangular Matrix", test_num);
            a = 8'd3; b = 8'd7;
            c = 8'd0; d = 8'd5;

            #1;


            check_outputs(8'h01, 8'h00, 8'd3, 8'd7, 8'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Row Rotation", test_num);
            a = 8'd0; b = 8'd2;
            c = 8'd1; d = 8'd3;

            #1;


            check_outputs(8'h00, 8'h01, 8'h01, 8'h03, 8'h00, 8'hFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Second Row", test_num);
            a = 8'd5;  b = 8'd12;
            c = 8'd0;  d = 8'd0;

            #1;


            check_outputs(8'h01, 8'h00, 8'd5, 8'd12, 8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Swap Rows with Zeros", test_num);
            a = 8'd0; b = 8'd0;
            c = 8'd4; d = 8'd0;

            #1;


            check_outputs(8'h00, 8'h01, 8'd4, 8'd0, 8'd0, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qr_decomposition Testbench");
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
        input [7:0] expected_q1;
        input [7:0] expected_q2;
        input [7:0] expected_r11;
        input [7:0] expected_r12;
        input [7:0] expected_r21;
        input [7:0] expected_r22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_r11 === (expected_r11 ^ r11 ^ expected_r11) &&
                expected_r12 === (expected_r12 ^ r12 ^ expected_r12) &&
                expected_r21 === (expected_r21 ^ r21 ^ expected_r21) &&
                expected_r22 === (expected_r22 ^ r22 ^ expected_r22)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         q1, q2, r11, r12, r21, r22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         expected_q1, expected_q2, expected_r11, expected_r12, expected_r21, expected_r22);
                $display("  Got:      q1=%h, q2=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         q1, q2, r11, r12, r21, r22);
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
