`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_I;
    reg D_I;
    wire D_O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_I(CLK_I),
        .D_I(D_I),
        .D_O(D_O)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_I = 0;
        forever #5 CLK_I = ~CLK_I;
    end

        task reset_dut;

        begin
            D_I = 0;
            repeat(3) @(posedge CLK_I);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition 0 -> 1", test_num);
            reset_dut();

            @(negedge CLK_I);
            D_I = 1;


            repeat(2) @(posedge CLK_I);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition 1 -> 0", test_num);
            reset_dut();


            @(negedge CLK_I);
            D_I = 1;
            repeat(2) @(posedge CLK_I);


            @(negedge CLK_I);
            D_I = 0;
            repeat(2) @(posedge CLK_I);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single cycle high pulse", test_num);
            reset_dut();

            @(negedge CLK_I);
            D_I = 1;
            @(negedge CLK_I);
            D_I = 0;



            @(posedge CLK_I);
            @(posedge CLK_I);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sustained high signal", test_num);
            reset_dut();

            @(negedge CLK_I);
            D_I = 1;
            repeat(5) @(posedge CLK_I);
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_D_O;
        begin
            if (expected_D_O === (expected_D_O ^ D_O ^ expected_D_O)) begin
                $display("PASS");
                $display("  Outputs: D_O=%b",
                         D_O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_O=%b",
                         expected_D_O);
                $display("  Got:      D_O=%b",
                         D_O);
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
        $dumpvars(0,CLK_I, D_I, D_O);
    end

endmodule
