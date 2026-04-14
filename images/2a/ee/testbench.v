`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a00;
    reg [7:0] a01;
    reg [7:0] a10;
    reg [7:0] a11;
    wire [7:0] b00;
    wire [7:0] b01;
    wire [7:0] b10;
    wire [7:0] b11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a00(a00),
        .a01(a01),
        .a10(a10),
        .a11(a11),
        .b00(b00),
        .b01(b01),
        .b10(b10),
        .b11(b11)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Identity Matrix", test_num);
            a00 = 8'h01; a01 = 8'h00;
            a10 = 8'h00; a11 = 8'h01;
            #1;

            check_outputs(8'h01, 8'h00, 8'h00, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Singular Matrix (Det=0)", test_num);
            a00 = 8'h01; a01 = 8'h01;
            a10 = 8'h01; a11 = 8'h01;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Matrix with Det=1", test_num);
            a00 = 8'h02; a01 = 8'h01;
            a10 = 8'h01; a11 = 8'h01;
            #1;

            check_outputs(8'h01, 8'hFF, 8'hFF, 8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Matrix with Det=-1", test_num);
            a00 = 8'h01; a01 = 8'h02;
            a10 = 8'h01; a11 = 8'h01;
            #1;

            check_outputs(8'hFF, 8'h02, 8'h01, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Larger values with Det=1", test_num);
            a00 = 8'd11; a01 = 8'd4;
            a10 = 8'd8;  a11 = 8'd3;
            #1;

            check_outputs(8'h03, 8'hFC, 8'hF8, 8'h0B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Zeros Matrix", test_num);
            a00 = 8'h00; a01 = 8'h00;
            a10 = 8'h00; a11 = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Dependent Rows (Det=0)", test_num);
            a00 = 8'd10; a01 = 8'd20;
            a10 = 8'd5;  a11 = 8'd10;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_b00;
        input [7:0] expected_b01;
        input [7:0] expected_b10;
        input [7:0] expected_b11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b00 === (expected_b00 ^ b00 ^ expected_b00) &&
                expected_b01 === (expected_b01 ^ b01 ^ expected_b01) &&
                expected_b10 === (expected_b10 ^ b10 ^ expected_b10) &&
                expected_b11 === (expected_b11 ^ b11 ^ expected_b11)) begin
                $display("PASS");
                $display("  Outputs: b00=%h, b01=%h, b10=%h, b11=%h",
                         b00, b01, b10, b11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b00=%h, b01=%h, b10=%h, b11=%h",
                         expected_b00, expected_b01, expected_b10, expected_b11);
                $display("  Got:      b00=%h, b01=%h, b10=%h, b11=%h",
                         b00, b01, b10, b11);
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
