`timescale 1ns/1ps

module lfsr_16bit_tb;

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
    lfsr_16bit dut (
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

        begin
            rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x0001, 1 cycle shift", test_num);
            seed = 16'h0001;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x0001, 11 cycle shifts", test_num);
            seed = 16'h0001;
            reset_dut();
            repeat(11) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0801);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0xFFFF, 2 cycle shifts", test_num);
            seed = 16'hFFFF;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0xACE1, 5 cycle shifts", test_num);
            seed = 16'hACE1;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h9C38);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x1234, 3 cycle shifts", test_num);
            seed = 16'h1234;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h91A4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x0000 (Lock state)", test_num);
            seed = 16'h0000;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Seed 0x8000, 1 cycle shift", test_num);
            seed = 16'h8000;
            reset_dut();
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_16bit Testbench");
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
