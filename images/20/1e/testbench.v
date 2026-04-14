`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a0;
    reg [3:0] a1;
    reg [3:0] a2;
    reg [3:0] a3;
    reg [3:0] a4;
    reg [3:0] x;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .x(x),
        .P(P)
    );
    task testcase001;

    begin
        test_num = 1;
        a0 = 4'd0; a1 = 4'd0; a2 = 4'd0; a3 = 4'd0; a4 = 4'd0; x = 4'd5;
        $display("Test %0d: All coefficients zero", test_num);
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a0 = 4'd10; a1 = 4'd0; a2 = 4'd0; a3 = 4'd0; a4 = 4'd0; x = 4'd15;
        $display("Test %0d: Constant polynomial (a0 only)", test_num);
        #1;

        check_outputs(16'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a0 = 4'd5; a1 = 4'd3; a2 = 4'd0; a3 = 4'd0; a4 = 4'd0; x = 4'd4;
        $display("Test %0d: Linear polynomial (a0 + a1*x)", test_num);

        #1;


        check_outputs(16'd17);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a0 = 4'd1; a1 = 4'd2; a2 = 4'd1; a3 = 4'd0; a4 = 4'd0; x = 4'd3;
        $display("Test %0d: Quadratic polynomial (x^2 + 2x + 1)", test_num);

        #1;


        check_outputs(16'd16);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a0 = 4'd0; a1 = 4'd0; a2 = 4'd0; a3 = 4'd1; a4 = 4'd0; x = 4'd5;
        $display("Test %0d: Cubic term only (x^3)", test_num);

        #1;


        check_outputs(16'd125);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a0 = 4'd0; a1 = 4'd0; a2 = 4'd0; a3 = 4'd0; a4 = 4'd1; x = 4'd4;
        $display("Test %0d: Quartic term only (x^4)", test_num);

        #1;


        check_outputs(16'd256);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a0 = 4'd1; a1 = 4'd1; a2 = 4'd1; a3 = 4'd1; a4 = 4'd1; x = 4'd10;
        $display("Test %0d: All coefficients unity, x=10", test_num);

        #1;


        check_outputs(16'd11111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a0 = 4'd15; a1 = 4'd15; a2 = 4'd0; a3 = 4'd0; a4 = 4'd0; x = 4'd2;
        $display("Test %0d: Large coefficients, linear", test_num);

        #1;


        check_outputs(16'd45);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a0 = 4'd0; a1 = 4'd0; a2 = 4'd0; a3 = 4'd0; a4 = 4'd1; x = 4'd15;
        $display("Test %0d: Max x, quartic term only", test_num);

        #1;


        check_outputs(16'd50625);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a0 = 4'd5; a1 = 4'd2; a2 = 4'd3; a3 = 4'd1; a4 = 4'd2; x = 4'd2;
        $display("Test %0d: Mixed values", test_num);


        #1;



        check_outputs(16'd61);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("polynomial_evaluator Testbench");
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
        input [15:0] expected_P;
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
