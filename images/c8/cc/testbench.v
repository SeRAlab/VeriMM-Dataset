`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg Clock;
    wire Cout;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Clock(Clock),
        .Cout(Cout),
        .Sum(Sum)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            A = 4'b0000;
            B = 4'b0000;
            Cin = 1'b0;
            @(posedge Clock);
            #1;
            $display("Circuit Initialized.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            reset_dut();
            A = 4'd0;
            B = 4'd0;
            Cin = 1'b0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple addition without carry", test_num);
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            Cin = 1'b0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with Cin", test_num);
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            Cin = 1'b1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary check - Carry out", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd0;
            Cin = 1'b1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum values", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            Cin = 1'b1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range overflow", test_num);
            reset_dut();
            A = 4'd10;
            B = 4'd10;
            Cin = 1'b0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternate bit patterns", test_num);
            reset_dut();
            A = 4'b1010;
            B = 4'b0101;
            Cin = 1'b0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_Sum;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
        $dumpvars(0,A, B, Cin, Clock, Cout, Sum);
    end

endmodule
