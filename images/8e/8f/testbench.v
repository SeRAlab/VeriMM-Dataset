`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg clk;
    reg en;
    reg en_carry;
    reg rst;
    wire Cout;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .clk(clk),
        .en(en),
        .en_carry(en_carry),
        .rst(rst),
        .Cout(Cout),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            en_carry = 0;
            A = 0;
            B = 0;
            Cin = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            en = 1; A = 4'd2; B = 4'd3; Cin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            en = 1; A = 4'd5; B = 4'd5; Cin = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            en = 1; A = 4'd10; B = 4'd10; Cin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            en = 1; en_carry = 1; A = 4'd10; B = 4'd5; Cin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            en = 1; en_carry = 0; A = 4'd10; B = 4'd5; Cin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            en = 0; A = 4'd7; B = 4'd1; Cin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            en = 1; en_carry = 0; A = 4'hF; B = 4'hF; Cin = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'hF);
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
        input expected_Cout;
        input [3:0] expected_S;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
        $dumpvars(0,A, B, Cin, clk, en, en_carry, rst, Cout, S);
    end

endmodule
