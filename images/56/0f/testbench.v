`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg sdram_clk;
    reg sdram_rst_;
    wire PAA;
    wire SET_MODE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sdram_clk(sdram_clk),
        .sdram_rst_(sdram_rst_),
        .PAA(PAA),
        .SET_MODE(SET_MODE)
    );

    // Clock generation (10ns period)
    initial begin
        sdram_clk = 0;
        forever #5 sdram_clk = ~sdram_clk;
    end

        task reset_dut;

        begin
            sdram_rst_ = 0;
            repeat(10) @(posedge sdram_clk);
            #1;
            sdram_rst_ = 1;
            $display("Reset released.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify outputs are 0 during active reset", test_num);
            sdram_rst_ = 0;
            repeat(50) @(posedge sdram_clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify PAA (Precharge All) triggers after init wait", test_num);
            reset_dut();


            fork : wait_paa
                begin
                    wait(PAA === 1'b1);
                    $display("Detected PAA pulse at %0t", $time);
                    disable wait_paa;
                end
                begin
                    repeat(10000) @(posedge sdram_clk);
                    $display("Timeout waiting for PAA");
                    disable wait_paa;
                end
            join


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify SET_MODE triggers at end of sequence", test_num);
            reset_dut();


            fork : wait_set_mode
                begin
                    wait(SET_MODE === 1'b1);
                    $display("Detected SET_MODE pulse at %0t", $time);
                    disable wait_set_mode;
                end
                begin
                    repeat(20000) @(posedge sdram_clk);
                    $display("Timeout waiting for SET_MODE");
                    disable wait_set_mode;
                end
            join


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify state stability after sequence completion", test_num);
            reset_dut();


            wait(SET_MODE === 1'b1);
            repeat(10) @(posedge sdram_clk);


            repeat(100) @(posedge sdram_clk);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_PAA;
        input expected_SET_MODE;
        begin
            if (expected_PAA === (expected_PAA ^ PAA ^ expected_PAA) &&
                expected_SET_MODE === (expected_SET_MODE ^ SET_MODE ^ expected_SET_MODE)) begin
                $display("PASS");
                $display("  Outputs: PAA=%b, SET_MODE=%b",
                         PAA, SET_MODE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PAA=%b, SET_MODE=%b",
                         expected_PAA, expected_SET_MODE);
                $display("  Got:      PAA=%b, SET_MODE=%b",
                         PAA, SET_MODE);
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
        $dumpvars(0,sdram_clk, sdram_rst_, PAA, SET_MODE);
    end

endmodule
