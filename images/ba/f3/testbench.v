`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    reg Cin;
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
        .CLK(CLK),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            A = 4'd0;
            B = 4'd0;
            Cin = 1'b0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: 5 + 3 + 0", test_num);
            A = 4'd5;
            B = 4'd3;
            Cin = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: 2 + 2 + 1", test_num);
            A = 4'd2;
            B = 4'd2;
            Cin = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: 10 + 10 + 0", test_num);
            A = 4'd10;
            B = 4'd10;
            Cin = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: 15 + 15 + 1", test_num);
            A = 4'd15;
            B = 4'd15;
            Cin = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: 8 + 8 + 0", test_num);
            A = 4'd8;
            B = 4'd8;
            Cin = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: 7 + 8 + 0", test_num);
            A = 4'd7;
            B = 4'd8;
            Cin = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: 0 + 0 + 0", test_num);
            A = 4'd0;
            B = 4'd0;
            Cin = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test Case %0d: 15 + 0 + 1", test_num);
            A = 4'd15;
            B = 4'd0;
            Cin = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
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
        $dumpvars(0,A, B, CLK, Cin, Cout, S);
    end

endmodule
