`timescale 1ns/1ps

module polynomial_evaluator_tb;

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
            test_num = 1;
            $display("\nTestcase %0d: All coefficients zero", test_num);
            a0 = 4'd0; a1 = 4'd0; a2 = 4'd0; a3 = 4'd0; x = 4'd5;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Constant polynomial (x is ignored)", test_num);
            a0 = 4'd12; a1 = 4'd0; a2 = 4'd0; a3 = 4'd0; x = 4'd10;

            #1;


            check_outputs(8'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: x = 0 (Only a0 remains)", test_num);
            a0 = 4'd7; a1 = 4'd15; a2 = 4'd15; a3 = 4'd15; x = 4'd0;

            #1;


            check_outputs(8'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Linear polynomial", test_num);
            a0 = 4'd5; a1 = 4'd3; a2 = 4'd0; a3 = 4'd0; x = 4'd4;

            #1;


            check_outputs(8'd17);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Quadratic polynomial", test_num);
            a0 = 4'd1; a1 = 4'd2; a2 = 4'd3; a3 = 4'd0; x = 4'd3;

            #1;


            check_outputs(8'd34);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Cubic polynomial (Small values)", test_num);
            a0 = 4'd1; a1 = 4'd1; a2 = 4'd1; a3 = 4'd1; x = 4'd4;

            #1;


            check_outputs(8'd85);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Polynomial with medium coefficients", test_num);
            a0 = 4'd10; a1 = 4'd2; a2 = 4'd4; a3 = 4'd1; x = 4'd3;

            #1;


            check_outputs(8'd79);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Maximum 8-bit result (Check near 255)", test_num);
            a0 = 4'd15; a1 = 4'd10; a2 = 4'd5; a3 = 4'd2; x = 4'd4;


            #1;



            check_outputs(8'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Overflow check (Large x)", test_num);
            a0 = 4'd0; a1 = 4'd0; a2 = 4'd0; a3 = 4'd1; x = 4'd7;


            #1;



            check_outputs(8'd87);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Max input values", test_num);
            a0 = 4'hf; a1 = 4'hf; a2 = 4'hf; a3 = 4'hf; x = 4'hf;



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
