`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] x;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .a(a),
        .b(b),
        .c(c),
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All zeros", test_num);
            a = 4'd0; b = 4'd0; c = 4'd0; x = 4'd0;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Linear (a=0)", test_num);
            a = 4'd0; b = 4'd5; c = 4'd10; x = 4'd2;

            #1;


            check_outputs(8'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Simple quadratic", test_num);
            a = 4'd1; b = 4'd1; c = 4'd1; x = 4'd2;

            #1;


            check_outputs(8'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: x=0 (Result should be c)", test_num);
            a = 4'd15; b = 4'd15; c = 4'd12; x = 4'd0;

            #1;


            check_outputs(8'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: x=15, a=1, b=0, c=0", test_num);
            a = 4'd1; b = 4'd0; c = 4'd0; x = 4'd15;

            #1;


            check_outputs(8'd225);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Result = 255", test_num);
            a = 4'd1; b = 4'd1; c = 4'd15; x = 4'd15;

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Small overflow (265 mod 256)", test_num);
            a = 4'd1; b = 4'd2; c = 4'd10; x = 4'd15;


            #1;



            check_outputs(8'd9);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Middle range", test_num);
            a = 4'd2; b = 4'd3; c = 4'd4; x = 4'd5;

            #1;


            check_outputs(8'd69);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest Case %0d: Max inputs (3615 mod 256)", test_num);
            a = 4'hf; b = 4'hf; c = 4'hf; x = 4'hf;


            #1;



            check_outputs(8'd31);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest Case %0d: Overflow to small value", test_num);
            a = 4'd2; b = 4'd0; c = 4'd0; x = 4'd12;


            #1;



            check_outputs(8'd32);
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
        input [7:0] expected_result;
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
