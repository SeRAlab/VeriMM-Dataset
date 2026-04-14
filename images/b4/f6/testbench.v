`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg SCD;
    reg SCE;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .SCD(SCD),
        .SCE(SCE),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SCD = 1;
            SCE = 0;
            D = 0;
            #10;
            SCD = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();



            SCD = 1;
            #2;
            $display("Test %0d: Asynchronous Reset (SCD=1) check", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            D = 1;
            SCE = 0;
            SCD = 0;
            @(posedge CLK);
            #2;
            $display("Test %0d: Normal Load D=1", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            D = 1; SCE = 0; SCD = 0;
            @(posedge CLK);
            #2;

            D = 0;
            @(posedge CLK);
            #2;
            $display("Test %0d: Normal Load D=0", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            D = 1; SCE = 0; SCD = 0;
            @(posedge CLK);
            #2;

            SCE = 1;
            D = 0;
            @(posedge CLK);
            #2;
            $display("Test %0d: SCE=1 Hold Logic (Holding Q=1)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            D = 0; SCE = 0; SCD = 0;
            @(posedge CLK);
            #2;

            SCE = 1;
            D = 1;
            @(posedge CLK);
            #2;
            $display("Test %0d: SCE=1 Hold Logic (Holding Q=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            D = 1; SCE = 0; SCD = 0;
            @(posedge CLK);
            #2;

            SCE = 1;
            D = 1;
            #3;
            SCD = 1;
            #1;
            $display("Test %0d: SCD Priority over SCE (Asynchronous)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            SCE = 0; SCD = 0;
            D = 1; @(posedge CLK);
            #2;
            D = 0; @(posedge CLK);
            #2;
            D = 1; @(posedge CLK);
            #2;
            $display("Test %0d: Sequential Toggling (Capture D=1)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_Q;
        input expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_N=%b",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_N=%b",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%b, Q_N=%b",
                         Q, Q_N);
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
        $dumpvars(0,CLK, D, SCD, SCE, Q, Q_N);
    end

endmodule
