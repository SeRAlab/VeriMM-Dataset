`timescale 1ns/1ps

module polynomial_evaluation_tb;

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
    polynomial_evaluation dut (
        .a(a),
        .b(b),
        .c(c),
        .x(x),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd0; b = 4'd0; c = 4'd0; x = 4'd0;
        $display("Test %0d: All inputs zero (P(0) = 0*0^2 + 0*0 + 0)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd5; b = 4'd3; c = 4'd7; x = 4'd0;
        $display("Test %0d: x is zero (P(0) = 5*0^2 + 3*0 + 7)", test_num);
        #1;

        check_outputs(8'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd0; b = 4'd4; c = 4'd2; x = 4'd3;
        $display("Test %0d: Linear evaluation (P(3) = 0*3^2 + 4*3 + 2)", test_num);
        #1;

        check_outputs(8'd14);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd2; b = 4'd0; c = 4'd0; x = 4'd5;
        $display("Test %0d: Pure quadratic (P(5) = 2*5^2 + 0 + 0)", test_num);
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd10; b = 4'd5; c = 4'd2; x = 4'd1;
        $display("Test %0d: x = 1 (P(1) = 10 + 5 + 2)", test_num);
        #1;

        check_outputs(8'd17);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd1; b = 4'd1; c = 4'd1; x = 4'd2;
        $display("Test %0d: Small values (P(2) = 1*4 + 1*2 + 1)", test_num);
        #1;

        check_outputs(8'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd1; b = 4'd1; c = 4'd1; x = 4'd15;
        $display("Test %0d: Near 8-bit limit (P(15) = 225 + 15 + 1)", test_num);
        #1;

        check_outputs(8'd241);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd3; b = 4'd0; c = 4'd15; x = 4'd4;
        $display("Test %0d: Zero linear coefficient (P(4) = 3*16 + 0 + 15)", test_num);
        #1;

        check_outputs(8'd63);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'd0; b = 4'd15; c = 4'd15; x = 4'd10;
        $display("Test %0d: Max coefficients linear (P(10) = 15*10 + 15)", test_num);
        #1;

        check_outputs(8'd165);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'd2; b = 4'd5; c = 4'd10; x = 4'd3;
        $display("Test %0d: Mixed evaluation (P(3) = 2*9 + 5*3 + 10)", test_num);
        #1;

        check_outputs(8'd43);
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
