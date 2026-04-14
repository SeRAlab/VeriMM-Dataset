`timescale 1ns/1ps

module jk_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    reg clk_en;
    reg reset;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jk_flip_flop dut (
        .J(J),
        .K(K),
        .clk(clk),
        .clk_en(clk_en),
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
            clk_en = 0;
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Verifying Reset state...");

            J = 1;
            K = 0;
            clk_en = 1;
            reset = 1;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Verify Q doesn't change when clk_en is low...");
            @(negedge clk);
            J = 1; K = 0; clk_en = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Set Operation (J=1, K=0)...");
            @(negedge clk);
            J = 1; K = 0; clk_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Synchronous Reset Operation (J=0, K=1)...");

            @(negedge clk);
            J = 1; K = 0; clk_en = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            J = 0; K = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Toggle Operation 0 -> 1 (J=1, K=1)...");
            @(negedge clk);
            J = 1; K = 1; clk_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Toggle Operation 1 -> 0 (J=1, K=1)...");

            @(negedge clk);
            J = 1; K = 0; clk_en = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            J = 1; K = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: Hold Operation (J=0, K=0)...");

            @(negedge clk);
            J = 1; K = 0; clk_en = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            J = 0; K = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase 008: Multi-cycle logic with clk_en toggle...");
            @(negedge clk);
            J = 1; K = 1; clk_en = 1;
            @(posedge clk);
            #2;
            @(negedge clk);
            clk_en = 0;
            @(posedge clk);
            #2;
            @(negedge clk);
            clk_en = 1;
            @(posedge clk);
            #2;
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
        $display("jk_flip_flop Testbench");
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
        $dumpvars(0,J, K, clk, clk_en, reset, Q);
    end

endmodule
