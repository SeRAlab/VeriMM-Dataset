`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [31:0] seed;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .seed(seed),
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
        #15;
        rst_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        seed = 32'hDEADBEEF;
        reset_dut();

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        seed = 32'h00000001;
        reset_dut();

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        seed = 32'h80000000;
        reset_dut();

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hC0000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        seed = 32'h00000003;
        reset_dut();

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        seed = 32'hF0000000;
        reset_dut();


        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFC000000);
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
        $dumpvars(0,clk, rst_n, seed, Q);
    end

endmodule
