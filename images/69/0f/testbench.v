`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg C;
    reg CLR;
    reg CP;
    reg D;
    reg LD;
    reg M;
    wire Qa;
    wire Qb;
    wire Qc;
    wire Qcc;
    wire Qd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .CLR(CLR),
        .CP(CP),
        .D(D),
        .LD(LD),
        .M(M),
        .Qa(Qa),
        .Qb(Qb),
        .Qc(Qc),
        .Qcc(Qcc),
        .Qd(Qd)
    );

    // Clock generation (10ns period)
    initial begin
        CLR = 0;
        forever #5 CLR = ~CLR;
    end

        task reset_dut;

        begin
            CLR = 1;
            LD = 0;
            M = 1;
            {D, C, B, A} = 4'b0000;
            #12;
            CLR = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Clear", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load (Value 10)", test_num);
            reset_dut();
            @(negedge CP);
            LD = 1;
            {D, C, B, A} = 4'b1010;
            @(posedge CP);
            #1;
            LD = 0;

            #1;


            check_outputs(0, 1, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Up (5 to 6)", test_num);
            reset_dut();
            @(negedge CP);
            LD = 1; {D, C, B, A} = 4'b0101;
            @(posedge CP);
            #1; LD = 0; M = 1;
            @(posedge CP);
            #1;
            #1;

            check_outputs(0, 1, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Terminal Count Up (15)", test_num);
            reset_dut();
            @(negedge CP);
            LD = 1; {D, C, B, A} = 4'b1111;
            @(posedge CP);
            #1; LD = 0; M = 1;

            #1;


            check_outputs(1, 1, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upward Wrap-around (15 to 0)", test_num);
            reset_dut();
            @(negedge CP);
            LD = 1; {D, C, B, A} = 4'b1111;
            @(posedge CP);
            #1; LD = 0; M = 1;
            @(posedge CP);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Down (10 to 9)", test_num);
            reset_dut();
            @(negedge CP);
            LD = 1; {D, C, B, A} = 4'b1010;
            @(posedge CP);
            #1; LD = 0; M = 0;
            @(posedge CP);
            #1;
            #1;

            check_outputs(1, 0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Terminal Count Down (0)", test_num);
            reset_dut();
            @(negedge CP);
            LD = 1; {D, C, B, A} = 4'b0000;
            @(posedge CP);
            #1; LD = 0; M = 0;

            #1;


            check_outputs(0, 0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Downward Wrap-around (0 to 15)", test_num);
            reset_dut();
            @(negedge CP);
            LD = 1; {D, C, B, A} = 4'b0000;
            @(posedge CP);
            #1; LD = 0; M = 0;
            @(posedge CP);
            #1;
            #1;

            check_outputs(1, 1, 1, 0, 1);
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
        input expected_Qa;
        input expected_Qb;
        input expected_Qc;
        input expected_Qcc;
        input expected_Qd;
        begin
            if (expected_Qa === (expected_Qa ^ Qa ^ expected_Qa) &&
                expected_Qb === (expected_Qb ^ Qb ^ expected_Qb) &&
                expected_Qc === (expected_Qc ^ Qc ^ expected_Qc) &&
                expected_Qcc === (expected_Qcc ^ Qcc ^ expected_Qcc) &&
                expected_Qd === (expected_Qd ^ Qd ^ expected_Qd)) begin
                $display("PASS");
                $display("  Outputs: Qa=%b, Qb=%b, Qc=%b, Qcc=%b, Qd=%b",
                         Qa, Qb, Qc, Qcc, Qd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Qa=%b, Qb=%b, Qc=%b, Qcc=%b, Qd=%b",
                         expected_Qa, expected_Qb, expected_Qc, expected_Qcc, expected_Qd);
                $display("  Got:      Qa=%b, Qb=%b, Qc=%b, Qcc=%b, Qd=%b",
                         Qa, Qb, Qc, Qcc, Qd);
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
        $dumpvars(0,A, B, C, CLR, CP, D, LD, M, Qa, Qb, Qc, Qcc, Qd);
    end

endmodule
