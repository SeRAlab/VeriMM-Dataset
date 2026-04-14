`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    wire LRCK;
    wire MCLK;
    wire SCLK;
    wire SDIN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .LRCK(LRCK),
        .MCLK(MCLK),
        .SCLK(SCLK),
        .SDIN(SDIN)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d...", test_num);


            repeat(5) @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(posedge Clk);
            #1;
            #1;

            check_outputs(LRCK, 1'b1, SCLK, SDIN);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            repeat(100) @(posedge Clk);
            #1;

            if (LRCK !== 1'bx && SCLK !== 1'bx && SDIN !== 1'bx) begin
                #1;

                check_outputs(LRCK, MCLK, SCLK, SDIN);
            end else begin
                $display("FAIL: Signals are in unknown state");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        reg initial_LRCK;
        begin
            reset_dut();
            initial_LRCK = LRCK;

            repeat(2000) @(posedge Clk);
            #1;


            #1;



            check_outputs(LRCK, MCLK, SCLK, SDIN);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            repeat(500) begin
                @(posedge Clk);
                if (SDIN == 1'b1) break;
            end
            #1;
            #1;

            check_outputs(LRCK, MCLK, SCLK, SDIN);
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
        input expected_LRCK;
        input expected_MCLK;
        input expected_SCLK;
        input expected_SDIN;
        begin
            if (expected_LRCK === (expected_LRCK ^ LRCK ^ expected_LRCK) &&
                expected_MCLK === (expected_MCLK ^ MCLK ^ expected_MCLK) &&
                expected_SCLK === (expected_SCLK ^ SCLK ^ expected_SCLK) &&
                expected_SDIN === (expected_SDIN ^ SDIN ^ expected_SDIN)) begin
                $display("PASS");
                $display("  Outputs: LRCK=%b, MCLK=%b, SCLK=%b, SDIN=%b",
                         LRCK, MCLK, SCLK, SDIN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LRCK=%b, MCLK=%b, SCLK=%b, SDIN=%b",
                         expected_LRCK, expected_MCLK, expected_SCLK, expected_SDIN);
                $display("  Got:      LRCK=%b, MCLK=%b, SCLK=%b, SDIN=%b",
                         LRCK, MCLK, SCLK, SDIN);
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
        $dumpvars(0,Clk, LRCK, MCLK, SCLK, SDIN);
    end

endmodule
