`timescale 1ns/1ps

module JK_FF_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    reg enable;
    reg reset;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_FF dut (
        .J(J),
        .K(K),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            J = 0;
            K = 0;
            enable = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Synchronous Set (J=1, K=0)");
            reset_dut();
            @(negedge clk);
            J = 1; K = 0; enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Synchronous Reset (J=0, K=1)");
            reset_dut();

            @(negedge clk); J = 1; K = 0; enable = 1;
            @(posedge clk);

            @(negedge clk); J = 0; K = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Toggle (J=1, K=1)");
            reset_dut();

            @(negedge clk); J = 1; K = 1; enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Double Toggle (J=1, K=1)");
            reset_dut();
            @(negedge clk); J = 1; K = 1; enable = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Hold State (J=0, K=0)");
            reset_dut();

            @(negedge clk); J = 1; K = 0; enable = 1;
            @(posedge clk);

            @(negedge clk); J = 0; K = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Enable=0 logic");
            reset_dut();
            @(negedge clk); J = 1; K = 0; enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Asynchronous Reset Override");
            reset_dut();

            @(negedge clk); J = 1; K = 0; enable = 1;
            @(posedge clk);
            #2;
            reset = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Multi-cycle Enable Hold");
            reset_dut();

            @(negedge clk); J = 1; K = 0; enable = 1;
            @(posedge clk);

            @(negedge clk); J = 1; K = 1; enable = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JK_FF Testbench");
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
        $dumpvars(0,J, K, clk, enable, reset, Q);
    end

endmodule
