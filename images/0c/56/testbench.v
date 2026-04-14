`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .reset(reset),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 1 Clock Cycle", test_num);
            reset_dut();
            @(posedge clk); #1;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 2 Clock Cycles", test_num);
            reset_dut();
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(32'h00000007);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 20 Clock Cycles", test_num);
            reset_dut();
            repeat(20) @(posedge clk); #1;
            #1;

            check_outputs(32'h001FFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 21 Clock Cycles (First Feedback Change)", test_num);
            reset_dut();
            repeat(21) @(posedge clk); #1;
            #1;

            check_outputs(32'h003FFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 22 Clock Cycles", test_num);
            reset_dut();
            repeat(22) @(posedge clk); #1;
            #1;

            check_outputs(32'h007FFFFC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, reset, lfsr_out);
    end

endmodule
