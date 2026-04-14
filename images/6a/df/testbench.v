`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] D;
    reg [3:0] S;
    reg load;
    reg reset;
    reg set;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .D(D),
        .S(S),
        .load(load),
        .reset(reset),
        .set(set),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        reset = 1;
        set = 0;
        load = 0;
        D = 4'b0000;
        S = 4'b0000;
        @(posedge Clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Synchronous Reset", test_num);
        reset_dut();


        #1;



        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Set Operation (Q <= S)", test_num);
        reset_dut();
        S = 4'hA;
        set = 1;
        @(posedge Clk);
        #1;
        set = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Load Operation (Q <= D)", test_num);
        reset_dut();
        D = 4'h5;
        load = 1;
        @(posedge Clk);
        #1;
        load = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Priority Test (Reset > Set > Load)", test_num);
        reset_dut();
        reset = 1;
        set = 1;
        load = 1;
        S = 4'hF;
        D = 4'hC;
        @(posedge Clk);
        #1;
        reset = 0;
        set = 0;
        load = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Priority Test (Set > Load)", test_num);
        reset_dut();
        set = 1;
        load = 1;
        S = 4'hB;
        D = 4'h3;
        @(posedge Clk);
        #1;
        set = 0;
        load = 0;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Data Retention", test_num);
        reset_dut();

        D = 4'h7;
        load = 1;
        @(posedge Clk);
        #1;
        load = 0;

        @(posedge Clk);
        #1;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Successive Loads", test_num);
        reset_dut();
        D = 4'h1;
        load = 1;
        @(posedge Clk);
        #1;
        D = 4'hE;
        @(posedge Clk);
        #1;
        load = 0;
        #1;

        check_outputs(4'hE);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
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
        $dumpvars(0,Clk, D, S, load, reset, set, Q);
    end

endmodule
