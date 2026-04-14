`timescale 1ns/1ps

module LFSR_32_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR_32 dut (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(negedge clk);
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset Check", test_num);
            rst_n = 0;
            #10;
            #1;

            check_outputs(32'h00000001);
            rst_n = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 1 Clock Cycle", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000003);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 2 Clock Cycles", test_num);
            reset_dut();
            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000006);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 5 Clock Cycles", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000036);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 10 Clock Cycles", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h000006DB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 15 Clock Cycles", test_num);
            reset_dut();
            repeat(14) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000DB6D);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LFSR_32 Testbench");
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
        input [31:0] expected_Q;
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
        $dumpvars(0,clk, rst_n, Q);
    end

endmodule
