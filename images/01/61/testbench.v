`timescale 1ns/1ps

module simple_rnn_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] H_old;
    reg [7:0] X;
    reg clk;
    reg rst;
    wire [3:0] H_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_rnn dut (
        .H_old(H_old),
        .X(X),
        .clk(clk),
        .rst(rst),
        .H_new(H_new)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            H_old = 4'h0;
            X = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Post-Reset Zero Input", test_num);
            X = 8'h00;
            H_old = 4'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input stimulus, Zero Hidden State", test_num);
            X = 8'h55;
            H_old = 4'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input, Active Hidden State", test_num);
            X = 8'h00;
            H_old = 4'hA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max Inputs (Saturation)", test_num);
            X = 8'hFF;
            H_old = 4'hF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Combined Stimulus", test_num);
            X = 8'hA5;
            H_old = 4'h3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_rnn Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_H_new;
        begin
            if (expected_H_new === (expected_H_new ^ H_new ^ expected_H_new)) begin
                $display("PASS");
                $display("  Outputs: H_new=%h",
                         H_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: H_new=%h",
                         expected_H_new);
                $display("  Got:      H_new=%h",
                         H_new);
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
        $dumpvars(0,H_old, X, clk, rst, H_new);
    end

endmodule
