`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    wire [9:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset state", test_num);
            reset_dut();
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single step increment (Enable=1)", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h003);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multi-step increment (5 steps)", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h03F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reaching all-ones state (9 steps)", test_num);
            reset_dut();
            en = 1;
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: First zero bit injection (10 steps)", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Checking Enable=0 holds state", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h00F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Full cycle verification (20 steps)", test_num);
            reset_dut();
            en = 1;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Synchronous reset during operation", test_num);
            reset_dut();
            en = 1;
            repeat(15) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(10'h001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
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
        input [9:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, en, reset, q);
    end

endmodule
