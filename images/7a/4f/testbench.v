`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cn;
    reg clk;
    wire [3:0] S;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cn(Cn),
        .clk(clk),
        .S(S),
        .V(V)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A <= 4'd0;
            B <= 4'd0;
            Cn <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A <= 4'd3;
            B <= 4'd2;
            Cn <= 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Addition 3 + 2", test_num);
            #1;

            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A <= 4'b0111;
            B <= 4'b0001;
            Cn <= 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Positive Overflow 7 + 1", test_num);
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A <= 4'b1111;
            B <= 4'b1111;
            Cn <= 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Negative Addition -1 + -1", test_num);
            #1;

            check_outputs(4'b1110, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A <= 4'b1000;
            B <= 4'b1111;
            Cn <= 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Negative Overflow -8 + -1", test_num);
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A <= 4'd5;
            B <= 4'd2;
            Cn <= 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction 5 - 2", test_num);
            #1;

            check_outputs(4'b0011, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A <= 4'b0111;
            B <= 4'b1111;
            Cn <= 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction Overflow 7 - (-1)", test_num);
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A <= 4'b1000;
            B <= 4'b0001;
            Cn <= 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction Overflow -8 - 1", test_num);
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A <= 4'b1100;
            B <= 4'b1100;
            Cn <= 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction Resulting in 0", test_num);
            #1;

            check_outputs(4'b0000, 1'b0);
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
        input [3:0] expected_S;
        input expected_V;
        begin
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: S=%h, V=%b",
                         S, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, V=%b",
                         expected_S, expected_V);
                $display("  Got:      S=%h, V=%b",
                         S, V);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, Cn, clk, S, V);
    end

endmodule
