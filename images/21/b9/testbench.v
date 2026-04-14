`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a0;
    reg [3:0] a1;
    reg [3:0] a2;
    reg [3:0] a3;
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
        .x(x),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All coefficients zero", test_num);
        a3 = 4'd0; a2 = 4'd0; a1 = 4'd0; a0 = 4'd0; x = 4'd10;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: x is zero", test_num);
        a3 = 4'd5; a2 = 4'd4; a1 = 4'd3; a0 = 4'd2; x = 4'd0;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: x is one", test_num);
        a3 = 4'd1; a2 = 4'd2; a1 = 4'd3; a0 = 4'd4; x = 4'd1;
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Linear polynomial", test_num);
        a3 = 4'd0; a2 = 4'd0; a1 = 4'd5; a0 = 4'd3; x = 4'd2;
        #1;

        check_outputs(16'h000D);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Quadratic polynomial", test_num);
        a3 = 4'd0; a2 = 4'd2; a1 = 4'd1; a0 = 4'd5; x = 4'd3;
        #1;

        check_outputs(16'h001A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Cubic polynomial small x", test_num);
        a3 = 4'd1; a2 = 4'd2; a1 = 4'd3; a0 = 4'd4; x = 4'd2;
        #1;

        check_outputs(16'h001A);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mixed zero coefficients", test_num);
        a3 = 4'd2; a2 = 4'd0; a1 = 4'd1; a0 = 4'd7; x = 4'd4;
        #1;

        check_outputs(16'h008B);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Maximum input values", test_num);
        a3 = 4'hF; a2 = 4'hF; a1 = 4'hF; a0 = 4'hF; x = 4'hF;
        #1;

        check_outputs(16'hD3E0);
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
