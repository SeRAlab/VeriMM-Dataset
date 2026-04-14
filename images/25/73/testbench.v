`timescale 1ns/1ps

module LFSR_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg rst;
    reg [15:0] seed;
    wire [15:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR dut (
        .clk(clk),
        .load(load),
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

        begin
            rst = 1;
            load = 0;
            seed = 16'h0000;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Loading Seed 0xACE1", test_num);
            reset_dut();
            seed = 16'hACE1;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(16'hACE1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single shift from 0x0001 (Expect 0x0002)", test_num);
            reset_dut();
            seed = 16'h0001;
            load = 1; @(posedge clk); #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Feedback from MSB (0x8000 -> 0x0001)", test_num);
            reset_dut();
            seed = 16'h8000;
            load = 1; @(posedge clk); #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Feedback from tap bit 13 (0x4000 -> 0x8001)", test_num);
            reset_dut();
            seed = 16'h4000;
            load = 1; @(posedge clk); #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h8001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multi-cycle check (0x1234 shift 1)", test_num);
            reset_dut();
            seed = 16'h1234;
            load = 1; @(posedge clk); #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h2469);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: 11 shifts from 0x0001 (Expect 0x0801)", test_num);
            reset_dut();
            seed = 16'h0001;
            load = 1; @(posedge clk); #1 load = 0;
            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(16'h0801);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: 5 shifts from 0xFFFF (Expect 0xFFE0)", test_num);
            reset_dut();
            seed = 16'hFFFF;
            load = 1; @(posedge clk); #1 load = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'hFFE0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LFSR Testbench");
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
        $dumpvars(0,clk, load, rst, seed, lfsr_out);
    end

endmodule
