`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg clk;
    reg reset;
    reg select;
    wire O;
    wire [15:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .select(select),
        .O(O),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            select = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (5 + 3)", test_num);
            reset_dut();
            A = 16'd5;
            B = 16'd3;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry-out (0xFFFF + 1)", test_num);
            reset_dut();
            A = 16'hFFFF;
            B = 16'h0001;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Addition (Carry Chain)", test_num);
            reset_dut();

            A = 16'hFFFF; B = 16'h0001; select = 0;
            @(posedge clk);

            #1 A = 16'h0001; B = 16'h0002; select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Subtraction (10 - 4)", test_num);
            reset_dut();
            A = 16'd10;
            B = 16'd4;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Borrow (5 - 10)", test_num);
            reset_dut();
            A = 16'd5;
            B = 16'd10;
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'hFFFB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Subtraction (Borrow Chain)", test_num);
            reset_dut();

            A = 16'h0000; B = 16'h0001; select = 1;
            @(posedge clk);

            #1 A = 16'd10; B = 16'd5; select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Add then Sub", test_num);
            reset_dut();

            A = 16'hFFFF; B = 16'h0001; select = 0;
            @(posedge clk);

            #1 A = 16'd10; B = 16'd2; select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values addition (FFFF + FFFF)", test_num);
            reset_dut();
            A = 16'hFFFF;
            B = 16'hFFFF;
            select = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'hFFFE);
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
        input expected_O;
        input [15:0] expected_S;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: O=%b, S=%h",
                         O, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b, S=%h",
                         expected_O, expected_S);
                $display("  Got:      O=%b, S=%h",
                         O, S);
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
        $dumpvars(0,A, B, clk, reset, select, O, S);
    end

endmodule
