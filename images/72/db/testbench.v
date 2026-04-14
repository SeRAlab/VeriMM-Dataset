`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg clk;
    wire [3:0] C;
    wire Cout;

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
        .C(C),
        .Cout(Cout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            Cin = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 4'd3;
            B = 4'd4;
            Cin = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd7, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 4'd5;
            B = 4'd2;
            Cin = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 4'd10;
            B = 4'd5;
            Cin = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 4'd8;
            B = 4'd8;
            Cin = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            Cin = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 4'd0;
            B = 4'd0;
            Cin = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 4'hF;
            B = 4'h0;
            Cin = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            A = 4'b1010;
            B = 4'b0101;
            Cin = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111, 1'b0);
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
        input [3:0] expected_C;
        input expected_Cout;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Cout === (expected_Cout ^ Cout ^ expected_Cout)) begin
                $display("PASS");
                $display("  Outputs: C=%h, Cout=%b",
                         C, Cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, Cout=%b",
                         expected_C, expected_Cout);
                $display("  Got:      C=%h, Cout=%b",
                         C, Cout);
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
        $dumpvars(0,A, B, Cin, clk, C, Cout);
    end

endmodule
