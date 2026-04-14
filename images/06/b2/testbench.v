`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [31:0] seed;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .seed(seed),
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
            enable = 0;
            seed = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Seed Loading", test_num);
            reset = 1;
            enable = 0;
            seed = 32'hACE1ACE1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(32'hACE1ACE1);
        end
        endtask

    task testcase002;

        reg [31:0] expected;
        begin
            test_num = 2;
            $display("Testcase %03d: Single Step Transition", test_num);
            reset_dut();
            seed = 32'h12345678;
            reset = 1;
            @(posedge clk); #1; reset = 0;

            enable = 1;
            expected = get_next_state(32'h12345678);
            @(posedge clk);
            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Enable Signal Low (Hold)", test_num);
            reset_dut();
            seed = 32'hFEEDFACE;
            reset = 1;
            @(posedge clk); #1; reset = 0;

            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFEEDFACE);
        end
        endtask

    task testcase004;

        reg [31:0] val;
        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Multi-cycle Transition", test_num);
            reset_dut();
            seed = 32'h00000001;
            reset = 1;
            @(posedge clk); #1; reset = 0;

            enable = 1;
            val = 32'h00000001;
            for(i = 0; i < 10; i = i + 1) begin
                val = get_next_state(val);
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(val);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Seed Change Verification", test_num);
            reset_dut();
            seed = 32'hA5A5A5A5;
            reset = 1;
            @(posedge clk); #1;
            reset = 0;
            #1;

            check_outputs(32'hA5A5A5A5);
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
        $dumpvars(0,clk, enable, reset, seed, lfsr_out);
    end

endmodule
