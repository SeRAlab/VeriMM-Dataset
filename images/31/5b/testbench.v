`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a0;
    reg [15:0] a1;
    reg [15:0] a2;
    reg [15:0] a3;
    reg [15:0] a4;
    reg [15:0] x;
    wire [31:0] result;

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
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: x = 0 (Result should be a0)", test_num);
            a0 = 16'h0005;
            a1 = 16'h000A;
            a2 = 16'h0002;
            a3 = 16'h0001;
            a4 = 16'h0003;
            x  = 16'h0000;

            #1;


            check_outputs(32'h00000005);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: x = 1 (Result should be sum of coefficients)", test_num);
            a0 = 16'h0001;
            a1 = 16'h0002;
            a2 = 16'h0003;
            a3 = 16'h0004;
            a4 = 16'h0005;
            x  = 16'h0001;

            #1;


            check_outputs(32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Quadratic evaluation", test_num);
            a0 = 16'h0002;
            a1 = 16'h0003;
            a2 = 16'h0001;
            a3 = 16'h0000;
            a4 = 16'h0000;
            x  = 16'h0002;

            #1;


            check_outputs(32'h0000000C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Cubic evaluation", test_num);
            a0 = 16'h0000;
            a1 = 16'h0000;
            a2 = 16'h0000;
            a3 = 16'h0002;
            a4 = 16'h0000;
            x  = 16'h0003;

            #1;


            check_outputs(32'h00000036);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Quartic evaluation", test_num);
            a0 = 16'h0000;
            a1 = 16'h0000;
            a2 = 16'h0000;
            a3 = 16'h0000;
            a4 = 16'h0001;
            x  = 16'h0004;

            #1;


            check_outputs(32'h00000100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mixed coefficients with x=2", test_num);
            a0 = 16'd10;
            a1 = 16'd5;
            a2 = 16'd3;
            a3 = 16'd2;
            a4 = 16'd1;
            x  = 16'd2;


            #1;



            check_outputs(32'd64);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: All zero inputs", test_num);
            a0 = 16'd0; a1 = 16'd0; a2 = 16'd0; a3 = 16'd0; a4 = 16'd0;
            x  = 16'd10;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: High power dominant", test_num);
            a0 = 16'd1;
            a1 = 16'd0;
            a2 = 16'd0;
            a3 = 16'd0;
            a4 = 16'd2;
            x  = 16'd5;

            #1;


            check_outputs(32'd1251);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
