`timescale 1ns/1ps

module qr_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a11;
    reg [15:0] a12;
    reg [15:0] a21;
    reg [15:0] a22;
    wire [15:0] q11;
    wire [15:0] q12;
    wire [15:0] q21;
    wire [15:0] q22;
    wire [15:0] r11;
    wire [15:0] r12;
    wire [15:0] r21;
    wire [15:0] r22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qr_decomposition dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .q11(q11),
        .q12(q12),
        .q21(q21),
        .q22(q22),
        .r11(r11),
        .r12(r12),
        .r21(r21),
        .r22(r22)
    );
    task set_matrix;

        input [15:0] v11;
        input [15:0] v12;
        input [15:0] v21;
        input [15:0] v22;
        begin
            a11 = v11;
            a12 = v12;
            a21 = v21;
            a22 = v22;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Matrix", test_num);
            set_matrix(16'h1000, 16'h0000,
                       16'h0000, 16'h1000);

            #1;


            check_outputs(16'h1000, 16'h0000, 16'h0000, 16'h1000,
                          16'h1000, 16'h0000, 16'h0000, 16'h1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Already Upper Triangular", test_num);
            set_matrix(16'h2000, 16'h3000,
                       16'h0000, 16'h4000);
            #1;

            check_outputs(16'h1000, 16'h0000, 16'h0000, 16'h1000,
                          16'h2000, 16'h3000, 16'h0000, 16'h4000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pythagorean Triple (3-4-5 column)", test_num);
            set_matrix(16'h0003, 16'h0000,
                       16'h0004, 16'h0005);


            #1;



            check_outputs(16'h0999, 16'hF334, 16'h0CCC, 16'h0999,
                          16'h0005, 16'h0004, 16'h0000, 16'h0003);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Matrix", test_num);
            set_matrix(16'h0000, 16'h0000,
                       16'h0000, 16'h0000);
            #1;

            check_outputs(16'h1000, 16'h0000, 16'h0000, 16'h1000,
                          16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pure Rotation Matrix", test_num);
            set_matrix(16'h0000, 16'hF000,
                       16'h1000, 16'h0000);
            #1;

            check_outputs(16'h0000, 16'hF000, 16'h1000, 16'h0000,
                          16'h1000, 16'h0000, 16'h0000, 16'h1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large R12 element", test_num);
            set_matrix(16'h0001, 16'h000A,
                       16'h0000, 16'h0001);
            #1;

            check_outputs(16'h1000, 16'h0000, 16'h0000, 16'h1000,
                          16'h0001, 16'h000A, 16'h0000, 16'h0001);
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
        input [15:0] expected_q11;
        input [15:0] expected_q12;
        input [15:0] expected_q21;
        input [15:0] expected_q22;
        input [15:0] expected_r11;
        input [15:0] expected_r12;
        input [15:0] expected_r21;
        input [15:0] expected_r22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q11 === (expected_q11 ^ q11 ^ expected_q11) &&
                expected_q12 === (expected_q12 ^ q12 ^ expected_q12) &&
                expected_q21 === (expected_q21 ^ q21 ^ expected_q21) &&
                expected_q22 === (expected_q22 ^ q22 ^ expected_q22) &&
                expected_r11 === (expected_r11 ^ r11 ^ expected_r11) &&
                expected_r12 === (expected_r12 ^ r12 ^ expected_r12) &&
                expected_r21 === (expected_r21 ^ r21 ^ expected_r21) &&
                expected_r22 === (expected_r22 ^ r22 ^ expected_r22)) begin
                $display("PASS");
                $display("  Outputs: q11=%h, q12=%h, q21=%h, q22=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         q11, q12, q21, q22, r11, r12, r21, r22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q11=%h, q12=%h, q21=%h, q22=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         expected_q11, expected_q12, expected_q21, expected_q22, expected_r11, expected_r12, expected_r21, expected_r22);
                $display("  Got:      q11=%h, q12=%h, q21=%h, q22=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         q11, q12, q21, q22, r11, r12, r21, r22);
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
