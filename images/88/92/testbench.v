`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c_;
    reg m;
    reg [3:0] s;
    wire co_;
    wire eq;
    wire [3:0] f;
    wire g;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_(c_),
        .m(m),
        .s(s),
        .co_(co_),
        .eq(eq),
        .f(f),
        .g(g),
        .p(p)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'b0101;
            b = 4'b1010;
            m = 1'b1;
            s = 4'b0000;
            c_ = 1'b1;
            $display("Test %0d: Logic NOT A (a=%b, s=0000, m=1)", test_num, a);

            #1;


            check_outputs(1'b1, 1'b0, 4'b1010, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'b1100;
            b = 4'b1010;
            m = 1'b1;
            s = 4'b0110;
            c_ = 1'b1;
            $display("Test %0d: Logic XOR (a=%b, b=%b, s=0110, m=1)", test_num, a, b);

            #1;


            check_outputs(1'b1, 1'b0, 4'b0110, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'b1100;
            b = 4'b1010;
            m = 1'b1;
            s = 4'b1011;
            c_ = 1'b1;
            $display("Test %0d: Logic AND (a=%b, b=%b, s=1011, m=1)", test_num, a, b);

            #1;


            check_outputs(1'b1, 1'b0, 4'b1000, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'd3;
            b = 4'd4;
            m = 1'b0;
            s = 4'b1001;
            c_ = 1'b1;
            $display("Test %0d: Arithmetic ADD (a=%d, b=%d, m=0, no c_)", test_num, a, b);

            #1;


            check_outputs(1'b1, 1'b0, 4'd7, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'd3;
            b = 4'd4;
            m = 1'b0;
            s = 4'b1001;
            c_ = 1'b0;
            $display("Test %0d: Arithmetic ADD with Carry (a=%d, b=%d, m=0, c_=0)", test_num, a, b);

            #1;


            check_outputs(1'b1, 1'b0, 4'd8, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'd12;
            b = 4'd5;
            m = 1'b0;
            s = 4'b1001;
            c_ = 1'b1;
            $display("Test %0d: Arithmetic ADD Overflow (a=%d, b=%d, m=0)", test_num, a, b);

            #1;


            check_outputs(1'b0, 1'b0, 4'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'd10;
            b = 4'd3;
            m = 1'b0;
            s = 4'b0110;
            c_ = 1'b0;
            $display("Test %0d: Arithmetic SUB (a=%d, b=%d, m=0, c_=0)", test_num, a, b);

            #1;


            check_outputs(1'b0, 1'b0, 4'd7, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'd5;
            b = 4'd0;
            m = 1'b0;
            s = 4'b1111;
            c_ = 1'b1;
            $display("Test %0d: Arithmetic A-1 (a=%d, s=1111, m=0)", test_num, a);

            #1;


            check_outputs(1'b0, 1'b0, 4'd4, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 4'b1010;
            b = 4'b1010;
            m = 1'b1;
            s = 4'b1001;
            c_ = 1'b1;
            $display("Test %0d: Equality Check (a=%b, b=%b, s=1001, m=1)", test_num, a, b);

            #1;


            check_outputs(1'b1, 1'b1, 4'b1111, 1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 4'b0000;
            b = 4'b1101;
            m = 1'b1;
            s = 4'b1010;
            c_ = 1'b1;
            $display("Test %0d: Logic Pass B (b=%b, s=1010, m=1)", test_num, b);

            #1;


            check_outputs(1'b1, 1'b0, 4'b1101, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_co_;
        input expected_eq;
        input [3:0] expected_f;
        input expected_g;
        input expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_co_ === (expected_co_ ^ co_ ^ expected_co_) &&
                expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: co_=%b, eq=%b, f=%h, g=%b, p=%b",
                         co_, eq, f, g, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co_=%b, eq=%b, f=%h, g=%b, p=%b",
                         expected_co_, expected_eq, expected_f, expected_g, expected_p);
                $display("  Got:      co_=%b, eq=%b, f=%h, g=%b, p=%b",
                         co_, eq, f, g, p);
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
