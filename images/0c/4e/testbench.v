`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] seed;
    wire cycle_completed;
    wire [7:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .cycle_completed(cycle_completed),
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
            @(negedge clk);
            rst = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset with Seed 0x01", test_num);
            seed = 8'h01;
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: State after 1 clock cycle (Seed 0x01)", test_num);
            seed = 8'h01;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: State after 4 clock cycles (Seed 0x01)", test_num);
            seed = 8'h01;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: State after 8 clock cycles (Seed 0x01)", test_num);
            seed = 8'h01;
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h1C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: State after 1 clock cycle (Seed 0xAA)", test_num);
            seed = 8'hAA;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify cycle_completed after 255 cycles", test_num);
            seed = 8'h01;
            reset_dut();

            repeat(254) @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h01);
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
        input expected_cycle_completed;
        input [7:0] expected_lfsr_out;
        begin
            if (expected_cycle_completed === (expected_cycle_completed ^ cycle_completed ^ expected_cycle_completed) &&
                expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: cycle_completed=%b, lfsr_out=%h",
                         cycle_completed, lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cycle_completed=%b, lfsr_out=%h",
                         expected_cycle_completed, expected_lfsr_out);
                $display("  Got:      cycle_completed=%b, lfsr_out=%h",
                         cycle_completed, lfsr_out);
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
        $dumpvars(0,clk, rst, seed, cycle_completed, lfsr_out);
    end

endmodule
