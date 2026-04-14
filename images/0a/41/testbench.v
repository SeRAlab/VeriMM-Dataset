`timescale 1ns/1ps

module lfsr_5bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] seed;
    wire [4:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_5bit dut (
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

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            seed = 5'h01;
            reset_dut();
            $display("Testcase %0d: Loading Seed 0x01", test_num);
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            seed = 5'h01;
            reset_dut();
            @(posedge clk);
            #1;
            $display("Testcase %0d: Seed 0x01 after 1 cycle", test_num);
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            seed = 5'h01;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase %0d: Seed 0x01 after 3 cycles", test_num);
            #1;

            check_outputs(5'h09);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            seed = 5'h01;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            $display("Testcase %0d: Seed 0x01 after 5 cycles", test_num);
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            seed = 5'h1F;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Seed 0x1F after 2 cycles", test_num);
            #1;

            check_outputs(5'h1C);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            seed = 5'h01;
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            $display("Testcase %0d: Seed 0x01 after 10 cycles", test_num);
            #1;

            check_outputs(5'h13);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            seed = 5'h14;
            reset_dut();
            @(posedge clk);
            #1;
            $display("Testcase %0d: Seed 0x14 after 1 cycle", test_num);
            #1;

            check_outputs(5'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_5bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [4:0] expected_lfsr_out;
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
