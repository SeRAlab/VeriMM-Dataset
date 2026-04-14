`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg D;
    wire Qa;
    wire Qb;
    wire Qc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .D(D),
        .Qa(Qa),
        .Qb(Qb),
        .Qc(Qc)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            D = 0;
            repeat (4) @(negedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single 1 Propagation to Qc", test_num);
            reset_dut();

            @(negedge Clk) D = 1;
            @(negedge Clk) D = 0;
            @(negedge Clk) D = 0;

            @(posedge Clk); #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill all stages with 1s", test_num);
            reset_dut();

            @(negedge Clk) D = 1;
            @(negedge Clk) D = 1;
            @(negedge Clk) D = 1;

            @(posedge Clk); #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pattern 101", test_num);
            reset_dut();

            @(negedge Clk) D = 1;
            @(negedge Clk) D = 0;
            @(negedge Clk) D = 1;

            @(posedge Clk); #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagate 0 through filled register", test_num);
            reset_dut();


            @(negedge Clk) D = 1;
            @(negedge Clk) D = 1;
            @(negedge Clk) D = 1;

            @(negedge Clk) D = 0;


            @(posedge Clk); #2;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Change D between edges", test_num);
            reset_dut();

            @(negedge Clk) D = 1;
            @(posedge Clk); #2;


            #1 D = 0;
            #1 D = 1;

            @(negedge Clk) D = 0;
            @(posedge Clk); #2;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
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
        begin
            if (expected_Qa === (expected_Qa ^ Qa ^ expected_Qa) &&
                expected_Qb === (expected_Qb ^ Qb ^ expected_Qb) &&
                expected_Qc === (expected_Qc ^ Qc ^ expected_Qc)) begin
                $display("PASS");
                $display("  Outputs: Qa=%b, Qb=%b, Qc=%b",
                         Qa, Qb, Qc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Qa=%b, Qb=%b, Qc=%b",
                         expected_Qa, expected_Qb, expected_Qc);
                $display("  Got:      Qa=%b, Qb=%b, Qc=%b",
                         Qa, Qb, Qc);
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
        $dumpvars(0,Clk, D, Qa, Qb, Qc);
    end

endmodule
