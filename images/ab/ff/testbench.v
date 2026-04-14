`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg clk;
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
            A = 4'b0000;
            B = 4'b0000;
            Cin = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd0; B = 4'd0; Cin = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd5; B = 4'd3; Cin = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd2; B = 4'd2; Cin = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd7; B = 4'd8; Cin = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd8; B = 4'd8; Cin = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd15; B = 4'd15; Cin = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'b1010; B = 4'b0101; Cin = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'b1010; B = 4'b0101; Cin = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'b1111; B = 4'b0000; Cin = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%b, B=%b, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd13; B = 4'd4; Cin = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(1'b1, 4'd1);
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
        $dumpvars(0,A, B, Cin, clk, Cout, S);
    end

endmodule
