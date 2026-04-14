`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] seed;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [4:0] s;
        begin
            reset = 1;
            seed = s;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut(5'h1F);
            @(posedge clk);
            #1;
            $display("Test Case %0d: Seed 0x1F after 1 cycle", test_num);
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut(5'h10);
            repeat(3) @(posedge clk);
            #1;
            $display("Test Case %0d: Seed 0x10 after 3 cycles", test_num);
            #1;

            check_outputs(5'h0E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut(5'h04);
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case %0d: Seed 0x04 after 5 cycles", test_num);
            #1;

            check_outputs(5'h17);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut(5'h08);
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case %0d: Seed 0x08 after 2 cycles", test_num);
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut(5'h15);
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case %0d: Seed 0x15 after 4 cycles", test_num);
            #1;

            check_outputs(5'h19);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        input [4:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, reset, seed, out);
    end

endmodule
