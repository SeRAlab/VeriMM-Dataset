`timescale 1ns/1ps

module JKFF_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    reg preset;
    reg rst;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JKFF dut (
        .J(J),
        .K(K),
        .clk(clk),
        .preset(preset),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            preset = 0;
            J = 0;
            K = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            rst = 1;
            J = 1; K = 0;
            #10;
            $display("Testcase %0d: Asynchronous Reset (Q should be 0)", test_num);
            #1;

            check_outputs(1'b0);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            preset = 1;
            #10;
            $display("Testcase %0d: Asynchronous Preset (Q should be 1)", test_num);
            #1;

            check_outputs(1'b1);
            preset = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            J <= 1;
            K <= 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Synchronous Set J=1, K=0 (Q should be 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            preset = 1; #5; preset = 0;
            @(posedge clk);
            J <= 0;
            K <= 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Synchronous Reset J=0, K=1 (Q should be 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            preset = 1; #5; preset = 0;
            @(posedge clk);
            J <= 0;
            K <= 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Synchronous Hold J=0, K=0 (Q should remain 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            J <= 1;
            K <= 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Toggle J=1, K=1 from 0 (Q should be 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();

            preset = 1; #5; preset = 0;
            @(posedge clk);
            J <= 1;
            K <= 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Toggle J=1, K=1 from 1 (Q should be 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            J <= 1; K <= 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase %0d: Two consecutive toggles (Q should be 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JKFF Testbench");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,J, K, clk, preset, rst, Q);
    end

endmodule
