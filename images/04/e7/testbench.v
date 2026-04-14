`timescale 1ns/1ps

module polynomial_evaluation_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a0;
    reg [3:0] a1;
    reg [3:0] a2;
    reg [3:0] a3;
    reg [3:0] x;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluation dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .x(x),
        .P(P)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All zeros", test_num);
        a3 = 4'd0; a2 = 4'd0; a1 = 4'd0; a0 = 4'd0; x = 4'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Constant term only (x=0)", test_num);
        a3 = 4'd5; a2 = 4'd4; a1 = 4'd3; a0 = 4'd10; x = 4'd0;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: x=1 (Sum of coefficients)", test_num);
        a3 = 4'd1; a2 = 4'd1; a1 = 4'd1; a0 = 4'd1; x = 4'd1;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Small x value", test_num);
        a3 = 4'd1; a2 = 4'd1; a1 = 4'd1; a0 = 4'd1; x = 4'd2;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Linear and constant terms near boundary", test_num);
        a3 = 4'd0; a2 = 4'd0; a1 = 4'd15; a0 = 4'd15; x = 4'd15;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Quadratic term x^2", test_num);
        a3 = 4'd0; a2 = 4'd1; a1 = 4'd0; a0 = 4'd0; x = 4'd15;
        #1;

        check_outputs(8'hE1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Cubic term overflow (343 mod 256)", test_num);
        a3 = 4'd1; a2 = 4'd0; a1 = 4'd0; a0 = 4'd0; x = 4'd7;
        #1;

        check_outputs(8'h57);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: General polynomial calculation", test_num);
        a3 = 4'd1; a2 = 4'd2; a1 = 4'd3; a0 = 4'd4; x = 4'd3;
        #1;

        check_outputs(8'h3A);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Large result near 255", test_num);
        a3 = 4'd2; a2 = 4'd0; a1 = 4'd0; a0 = 4'd0; x = 4'd5;
        #1;

        check_outputs(8'hFA);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Full coefficients maximum x overflow", test_num);
        a3 = 4'd15; a2 = 4'd15; a1 = 4'd15; a0 = 4'd15; x = 4'd15;
        #1;

        check_outputs(8'hE0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("polynomial_evaluation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
