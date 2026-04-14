`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a00;
    reg [3:0] a01;
    reg [3:0] a10;
    reg [3:0] a11;
    reg [3:0] b00;
    reg [3:0] b01;
    reg [3:0] b10;
    reg [3:0] b11;
    wire [3:0] c00;
    wire [3:0] c01;
    wire [3:0] c10;
    wire [3:0] c11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .a00(a00),
        .a01(a01),
        .a10(a10),
        .a11(a11),
        .b00(b00),
        .b01(b01),
        .b10(b10),
        .b11(b11),
        .c00(c00),
        .c01(c01),
        .c10(c10),
        .c11(c11)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication by Zero Matrix", test_num);
            a00 = 4'h0; a01 = 4'h0; a10 = 4'h0; a11 = 4'h0;
            b00 = 4'h5; b01 = 4'hA; b10 = 4'hF; b11 = 4'h3;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Element-wise multiplication by 1", test_num);
            a00 = 4'h1; a01 = 4'h1; a10 = 4'h1; a11 = 4'h1;
            b00 = 4'h4; b01 = 4'h7; b10 = 4'h2; b11 = 4'h9;
            #1;

            check_outputs(4'h4, 4'h7, 4'h2, 4'h9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic multiplication (no overflow)", test_num);
            a00 = 4'h2; a01 = 4'h3; a10 = 4'h1; a11 = 4'h5;
            b00 = 4'h4; b01 = 4'h2; b10 = 4'h8; b11 = 4'h3;

            #1;


            check_outputs(4'h8, 4'h6, 4'h8, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow/Truncation check (4-bit wrap-around)", test_num);
            a00 = 4'h4; a01 = 4'h8; a10 = 4'h9; a11 = 4'hA;
            b00 = 4'h4; b01 = 4'h2; b10 = 4'h2; b11 = 4'h3;

            #1;


            check_outputs(4'h0, 4'h0, 4'h2, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (15 * 15)", test_num);
            a00 = 4'hF; a01 = 4'hF; a10 = 4'hF; a11 = 4'hF;
            b00 = 4'hF; b01 = 4'hF; b10 = 4'hF; b11 = 4'hF;

            #1;


            check_outputs(4'h1, 4'h1, 4'h1, 4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_factorization Testbench");
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
        input [3:0] expected_c00;
        input [3:0] expected_c01;
        input [3:0] expected_c10;
        input [3:0] expected_c11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c00 === (expected_c00 ^ c00 ^ expected_c00) &&
                expected_c01 === (expected_c01 ^ c01 ^ expected_c01) &&
                expected_c10 === (expected_c10 ^ c10 ^ expected_c10) &&
                expected_c11 === (expected_c11 ^ c11 ^ expected_c11)) begin
                $display("PASS");
                $display("  Outputs: c00=%h, c01=%h, c10=%h, c11=%h",
                         c00, c01, c10, c11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c00=%h, c01=%h, c10=%h, c11=%h",
                         expected_c00, expected_c01, expected_c10, expected_c11);
                $display("  Got:      c00=%h, c01=%h, c10=%h, c11=%h",
                         c00, c01, c10, c11);
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
