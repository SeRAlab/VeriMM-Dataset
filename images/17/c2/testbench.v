`timescale 1ns/1ps

module LFSR_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] seed;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR_32bit dut (
        .clk(clk),
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

        input [31:0] s;
        begin
            @(posedge clk);
            #1;
            seed = s;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut(32'hACE12345);

            #1;


            check_outputs(32'hACE12345);
        end
        endtask

    task testcase002;

        begin
            reset_dut(32'h12345678);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h2468ACF1);
        end
        endtask

    task testcase003;

        begin
            reset_dut(32'h12345678);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h48D159E3);
        end
        endtask

    task testcase004;

        begin
            reset_dut(32'hFFFFFFFF);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        integer i;
        reg [31:0] expected_val;
        reg fb;
        begin
            expected_val = 32'h12345678;
            reset_dut(expected_val);

            for(i = 0; i < 10; i = i + 1) begin
                fb = expected_val[31] ^ expected_val[21] ^ expected_val[1] ^ expected_val[0];
                expected_val = {expected_val[30:0], fb};
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LFSR_32bit Testbench");
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
        $dumpvars(0,clk, reset, seed, lfsr_out);
    end

endmodule
