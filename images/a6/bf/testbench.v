`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk125;
    wire clk;
    wire clk_locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk125(clk125),
        .clk(clk),
        .clk_locked(clk_locked)
    );

    // Clock generation (10ns period)
    initial begin
        clk125 = 0;
        forever #5 clk125 = ~clk125;
    end

        task reset_dut;

        begin
            @(posedge clk125);
            @(posedge clk125);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking first toggle", test_num);
            reset_dut();



            @(posedge clk125);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        reg val_at_t1;
        begin
            test_num = 2;
            $display("Testcase %03d: Verifying frequency division", test_num);
            reset_dut();

            @(posedge clk125);
            #1 val_at_t1 = clk;

            @(posedge clk125);
            #1;


            #1;



            check_outputs(~val_at_t1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Long term stability and lock check", test_num);
            reset_dut();


            repeat(10) @(posedge clk125);
            #1;



            #1;




            check_outputs(clk, 1'b1);
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
        input expected_clk;
        input expected_clk_locked;
        begin
            if (expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_clk_locked === (expected_clk_locked ^ clk_locked ^ expected_clk_locked)) begin
                $display("PASS");
                $display("  Outputs: clk=%b, clk_locked=%b",
                         clk, clk_locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b, clk_locked=%b",
                         expected_clk, expected_clk_locked);
                $display("  Got:      clk=%b, clk_locked=%b",
                         clk, clk_locked);
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
        $dumpvars(0,clk125, clk, clk_locked);
    end

endmodule
