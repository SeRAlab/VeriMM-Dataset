`timescale 1ns/1ps

module LFSR_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] seed;
    wire [15:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR_16bit dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [15:0] s;
        begin
            @(posedge clk);
            #1;
            rst = 1;
            seed = s;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset value check (Seed ACE1)", test_num);
            reset_dut(16'hACE1);
            #1;

            check_outputs(16'hACE1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 cycle transition from ACE1", test_num);
            reset_dut(16'hACE1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h59C2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 2 cycles transition from ACE1", test_num);
            reset_dut(16'hACE1);
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(16'hB385);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High bit feedback test (Seed 8000)", test_num);
            reset_dut(16'h8000);
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple shift test (Seed 0001)", test_num);
            reset_dut(16'h0001);
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0002);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 cycles transition from ACE1", test_num);
            reset_dut(16'hACE1);
            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(16'h670B);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 11 cycles transition from 0001", test_num);
            reset_dut(16'h0001);
            repeat(11) @(posedge clk);
            #1;



            #1;




            check_outputs(16'h0801);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits high check (Seed FFFF)", test_num);
            reset_dut(16'hFFFF);
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LFSR_16bit Testbench");
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
        input [15:0] expected_lfsr_out;
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
        $dumpvars(0,clk, rst, seed, lfsr_out);
    end

endmodule
