`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] U00;
    reg [7:0] U01;
    reg [7:0] U10;
    reg [7:0] U11;
    reg [7:0] V00;
    reg [7:0] V01;
    reg [7:0] V10;
    reg [7:0] V11;
    wire [15:0] R00;
    wire [15:0] R01;
    wire [15:0] R10;
    wire [15:0] R11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .U00(U00),
        .U01(U01),
        .U10(U10),
        .U11(U11),
        .V00(V00),
        .V01(V01),
        .V10(V10),
        .V11(V11),
        .R00(R00),
        .R01(R01),
        .R10(R10),
        .R11(R11)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic small integers", test_num);

            U00 = 8'd1; U01 = 8'd2; U10 = 8'd3; U11 = 8'd4;
            V00 = 8'd5; V01 = 8'd6; V10 = 8'd7; V11 = 8'd8;




            #1;





            check_outputs(16'h0013, 16'h0016, 16'h002B, 16'h0032);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix (V is Identity)", test_num);

            U00 = 8'd10; U01 = 8'd20; U10 = 8'd30; U11 = 8'd40;
            V00 = 8'd1;  V01 = 8'd0;  V10 = 8'd0;  V11 = 8'd1;

            #1;


            check_outputs(16'd10, 16'd20, 16'd30, 16'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Matrix", test_num);

            U00 = 8'hFF; U01 = 8'hFF; U10 = 8'hFF; U11 = 8'hFF;
            V00 = 8'h00; V01 = 8'h00; V10 = 8'h00; V11 = 8'h00;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Diagonal Matrices", test_num);

            U00 = 8'd2; U01 = 8'd0; U10 = 8'd0; U11 = 8'd4;
            V00 = 8'd8; V01 = 8'd0; V10 = 8'd0; V11 = 8'd16;




            #1;





            check_outputs(16'h0010, 16'h0000, 16'h0000, 16'h0040);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Medium values (No Overflow)", test_num);

            U00 = 8'd128; U01 = 8'd128; U10 = 8'd128; U11 = 8'd128;
            V00 = 8'd128; V01 = 8'd128; V10 = 8'd128; V11 = 8'd128;

            #1;


            check_outputs(16'h8000, 16'h8000, 16'h8000, 16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Scalar-like scaling", test_num);

            U00 = 8'd255; U01 = 8'd0;   U10 = 8'd0;   U11 = 8'd255;
            V00 = 8'd2;   V01 = 8'd3;   V10 = 8'd4;   V11 = 8'd5;




            #1;





            check_outputs(16'h01FE, 16'h02FD, 16'h03FC, 16'h04FB);
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
        input [15:0] expected_R00;
        input [15:0] expected_R01;
        input [15:0] expected_R10;
        input [15:0] expected_R11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R00 === (expected_R00 ^ R00 ^ expected_R00) &&
                expected_R01 === (expected_R01 ^ R01 ^ expected_R01) &&
                expected_R10 === (expected_R10 ^ R10 ^ expected_R10) &&
                expected_R11 === (expected_R11 ^ R11 ^ expected_R11)) begin
                $display("PASS");
                $display("  Outputs: R00=%h, R01=%h, R10=%h, R11=%h",
                         R00, R01, R10, R11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R00=%h, R01=%h, R10=%h, R11=%h",
                         expected_R00, expected_R01, expected_R10, expected_R11);
                $display("  Got:      R00=%h, R01=%h, R10=%h, R11=%h",
                         R00, R01, R10, R11);
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
