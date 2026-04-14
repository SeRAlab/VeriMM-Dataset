`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg j;
    reg k;
    reg r;
    reg reset;
    reg s;
    reg t;
    wire q;
    wire qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .j(j),
        .k(k),
        .r(r),
        .reset(reset),
        .s(s),
        .t(t),
        .q(q),
        .qn(qn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0; j = 0; k = 0; t = 0; s = 0; r = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Async/Sync Reset Check");
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: D Flip-Flop Set (D=1)");
            reset_dut();
            d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: D Flip-Flop Reset (D=0)");
            reset_dut();

            d = 1;
            @(posedge clk);
            #2;

            d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: JK Flip-Flop Set (J=1, K=0)");
            reset_dut();
            j = 1; k = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: JK Flip-Flop Reset (J=0, K=1)");
            reset_dut();

            j = 1; k = 0;
            @(posedge clk);
            #2;

            j = 0; k = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: JK Flip-Flop Toggle (J=1, K=1)");
            reset_dut();
            j = 1; k = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: JK Flip-Flop Hold (J=0, K=0)");
            reset_dut();
            j = 1; k = 0;
            @(posedge clk);
            #2;
            j = 0; k = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: T Flip-Flop Toggle (T=1)");
            reset_dut();
            t = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: T Flip-Flop Hold (T=0)");
            reset_dut();
            t = 1;
            @(posedge clk);
            #2;
            t = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: SR Flip-Flop Set (S=1, R=0)");
            reset_dut();
            s = 1; r = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: SR Flip-Flop Reset (S=0, R=1)");
            reset_dut();
            s = 1; r = 0;
            @(posedge clk);
            #2;
            s = 0; r = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: SR Flip-Flop Hold (S=0, R=0)");
            reset_dut();
            s = 1; r = 0;
            @(posedge clk);
            #2;
            s = 0; r = 0;
            @(posedge clk);
            #2;
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input expected_q;
        input expected_qn;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qn === (expected_qn ^ qn ^ expected_qn)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qn=%b",
                         q, qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qn=%b",
                         expected_q, expected_qn);
                $display("  Got:      q=%b, qn=%b",
                         q, qn);
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
        $dumpvars(0,clk, d, j, k, r, reset, s, t, q, qn);
    end

endmodule
