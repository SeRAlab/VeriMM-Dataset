`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg Clear;
    reg Load;
    reg clock;
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
        .Clear(Clear),
        .Load(Load),
        .clock(clock),
        .Cout(Cout),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            Clear = 1;
            Load = 0;
            A = 4'b0;
            B = 4'b0;
            Cin = 0;
            @(posedge clock);
            #1;
            Clear = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Clear", test_num);
            reset_dut();

            A = 4'hF; B = 4'hF; Cin = 1;
            Clear = 1; Load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load (S=A, Cout=Cin)", test_num);
            reset_dut();
            A = 4'hA; B = 4'h5; Cin = 1;
            Clear = 0; Load = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (No Carry)", test_num);
            reset_dut();
            A = 4'h3; B = 4'h4; Cin = 0;
            Clear = 0; Load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Carry-In", test_num);
            reset_dut();
            A = 4'h2; B = 4'h2; Cin = 1;
            Clear = 0; Load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Carry-Out", test_num);
            reset_dut();
            A = 4'h8; B = 4'h8; Cin = 0;
            Clear = 0; Load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Sum (F + F + 1)", test_num);
            reset_dut();
            A = 4'hF; B = 4'hF; Cin = 1;
            Clear = 0; Load = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (Clear vs Load)", test_num);
            reset_dut();
            A = 4'h5; B = 4'h5; Cin = 0;
            Clear = 1; Load = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from Load to Addition", test_num);
            reset_dut();

            A = 4'hC; B = 4'h0; Cin = 0;
            Clear = 0; Load = 1;
            @(posedge clock);
            #1;

            A = 4'h1; B = 4'h1; Cin = 1;
            Load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 4'h3);
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
        $dumpvars(0,A, B, Cin, Clear, Load, clock, Cout, S);
    end

endmodule
