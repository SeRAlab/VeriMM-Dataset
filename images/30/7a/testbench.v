`timescale 1ns/1ps

module jk_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
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
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Async Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Set Operation (J=1, K=0)", test_num);
            reset_dut();
            @(negedge clk);
            J = 1; K = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reset Operation (J=0, K=1)", test_num);
            reset_dut();

            @(negedge clk);
            J = 1; K = 0;
            @(negedge clk);

            J = 0; K = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hold Operation at 0 (J=0, K=0)", test_num);
            reset_dut();
            @(negedge clk);
            J = 0; K = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Hold Operation at 1 (J=0, K=0)", test_num);
            reset_dut();
            @(negedge clk);
            J = 1; K = 0;
            @(negedge clk);
            J = 0; K = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Toggle Operation (0 -> 1)", test_num);
            reset_dut();
            @(negedge clk);
            J = 1; K = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Toggle Operation (1 -> 0)", test_num);
            reset_dut();
            @(negedge clk);
            J = 1; K = 0;
            @(negedge clk);
            J = 1; K = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Async Reset Priority Over J/K", test_num);
            reset_dut();
            @(negedge clk);
            J = 1; K = 0;
            #2;
            reset = 1;
            #5;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Consecutive Toggles", test_num);
            reset_dut();
            @(negedge clk);
            J = 1; K = 1;
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
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
        testcase009();
        
        
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
        $dumpvars(0,J, K, clk, reset, Q);
    end

endmodule
