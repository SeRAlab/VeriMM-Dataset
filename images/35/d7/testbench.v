`timescale 1ns/1ps

module DWT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] sample;
    wire [3:0] hpf_out;
    wire [3:0] lpf_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT dut (
        .clk(clk),
        .sample(sample),
        .hpf_out(hpf_out),
        .lpf_out(lpf_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sample = 4'd0;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            sample = 4'd0;
            repeat(4) @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Constant DC (All 8s)", test_num);
            reset_dut();
            sample = 4'd8;
            repeat(4) @(posedge clk);


            #1;



            check_outputs(4'd0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High Frequency Toggle", test_num);
            reset_dut();
            @(posedge clk) sample = 4'd15;
            @(posedge clk) sample = 4'd0;
            @(posedge clk) sample = 4'd15;
            @(posedge clk) sample = 4'd0;
            @(posedge clk);

            #1;


            check_outputs(4'd15, 4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Ramp Input", test_num);
            reset_dut();
            @(posedge clk) sample = 4'd1;
            @(posedge clk) sample = 4'd2;
            @(posedge clk) sample = 4'd3;
            @(posedge clk) sample = 4'd4;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Impulse", test_num);
            reset_dut();
            @(posedge clk) sample = 4'd12;
            @(posedge clk) sample = 4'd0;
            @(posedge clk) sample = 4'd0;
            @(posedge clk) sample = 4'd0;
            @(posedge clk);

            #1;


            check_outputs(4'd12, 4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT Testbench");
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
        input [3:0] expected_hpf_out;
        input [3:0] expected_lpf_out;
        begin
            if (expected_hpf_out === (expected_hpf_out ^ hpf_out ^ expected_hpf_out) &&
                expected_lpf_out === (expected_lpf_out ^ lpf_out ^ expected_lpf_out)) begin
                $display("PASS");
                $display("  Outputs: hpf_out=%h, lpf_out=%h",
                         hpf_out, lpf_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hpf_out=%h, lpf_out=%h",
                         expected_hpf_out, expected_lpf_out);
                $display("  Got:      hpf_out=%h, lpf_out=%h",
                         hpf_out, lpf_out);
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
        $dumpvars(0,clk, sample, hpf_out, lpf_out);
    end

endmodule
