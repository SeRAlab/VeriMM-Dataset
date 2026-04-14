`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg enable;
    reg reset;
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
        .clk(clk),
        .enable(enable),
        .reset(reset),
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
            reset = 1;
            enable = 0;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 4 + 3 (No carry)", test_num);
            A = 4'd4;
            B = 4'd3;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 8 + 9 (With carry)", test_num);
            A = 4'd8;
            B = 4'd9;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 5 + 0", test_num);
            A = 4'd5;
            B = 4'd0;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 15 + 15 (Max sum)", test_num);
            A = 4'd15;
            B = 4'd15;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Enable signal check (Enable=0)", test_num);
            A = 4'd10;
            B = 4'd2;
            enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Reset priority check", test_num);
            A = 4'd7;
            B = 4'd7;
            enable = 1;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Addition resulting in exact overflow (10 + 6)", test_num);
            A = 4'd10;
            B = 4'd6;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple cycles calculation", test_num);


            A = 4'd1; B = 4'd1; enable = 1;
            @(posedge clk);


            A = 4'd5; B = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd10);
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
        $dumpvars(0,A, B, clk, enable, reset, Cout, S);
    end

endmodule
