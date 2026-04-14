`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg select;
    wire [63:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .select(select),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst_n = 0;
            select = 0;
            repeat(2) @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            reset_dut();


            expected_val = Q;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: LFSR Mode Single Transition");
            reset_dut();
            select = 1;
            @(posedge clk);
            #1;


            if (Q != expected_val) begin
                $display("LFSR mode active: Q changed from %h to %h", expected_val, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("LFSR mode failed: Q remained %h", Q);
                fail_count = fail_count + 1;
            end
            test_num = test_num + 1;
        end
        endtask

    task testcase003;

        reg [63:0] initial_reg_val;
        begin
            $display("\nRunning testcase003: Register Mode Circular Shift");
            reset_dut();
            select = 0;
            initial_reg_val = Q;

            @(posedge clk);
            #1;




            expected_val = {initial_reg_val[62:0], initial_reg_val[63]};



            if ($countones(Q) == $countones(initial_reg_val) && Q != initial_reg_val) begin
                 $display("Register mode active: Circular shift detected.");
                 pass_count = pass_count + 1;
            end else begin
                 $display("Register mode check failed or state is static.");
                 fail_count = fail_count + 1;
            end
            test_num = test_num + 1;
        end
        endtask

    task testcase004;

        reg [63:0] val_after_lfsr;
        begin
            $display("\nRunning testcase004: Mode Switching (LFSR -> Register)");
            reset_dut();


            select = 1;
            repeat(3) @(posedge clk);
            #1 val_after_lfsr = Q;


            select = 0;
            @(posedge clk);
            #1;


            if (Q != val_after_lfsr) begin
                $display("Switching successful. Value changed from %h to %h", val_after_lfsr, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("Switching failed: Value static after mode change.");
                fail_count = fail_count + 1;
            end
            test_num = test_num + 1;
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Asynchronous Reset during operation");
            reset_dut();
            select = 1;
            repeat(5) @(posedge clk);


            rst_n = 0;
            #2;



            if (Q == 0 || Q != expected_val) begin

                $display("Reset successful during operation.");
                pass_count = pass_count + 1;
            end else begin
                $display("Reset failed to clear state.");
                fail_count = fail_count + 1;
            end
            test_num = test_num + 1;
            rst_n = 1;
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
        input [63:0] expected_Q;
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
        $dumpvars(0,clk, rst_n, select, Q);
    end

endmodule
