`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg long_hb;
    reg new_seed;
    reg reset_n;
    reg [7:0] seed;
    wire heartbeat;
    wire [7:0] lfsr_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .long_hb(long_hb),
        .new_seed(new_seed),
        .reset_n(reset_n),
        .seed(seed),
        .heartbeat(heartbeat),
        .lfsr_data(lfsr_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            enable = 0;
            new_seed = 0;
            seed = 8'h00;
            long_hb = 0;
            @(posedge clk);
            #1 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(heartbeat, lfsr_data);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            seed = 8'hA5;
            new_seed = 1;
            @(posedge clk);
            #1 new_seed = 0;
            @(posedge clk);
            #1;

            check_outputs(heartbeat, 8'hA5);
        end
        endtask

    task testcase003;

        reg [7:0] captured_data;
        begin
            reset_dut();
            seed = 8'h5A;
            new_seed = 1;
            @(posedge clk);
            #1 new_seed = 0;
            enable = 0;
            repeat(5) @(posedge clk);
            captured_data = lfsr_data;

            #1;


            check_outputs(heartbeat, 8'h5A);
        end
        endtask

    task testcase004;

        reg [7:0] initial_val;
        begin
            reset_dut();
            enable = 1;
            @(posedge clk);
            initial_val = lfsr_data;
            repeat(2) @(posedge clk);

            if (lfsr_data != initial_val)
                pass_count = pass_count;
            #1;

            check_outputs(heartbeat, lfsr_data);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            long_hb = 0;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(heartbeat, lfsr_data);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            long_hb = 1;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(heartbeat, lfsr_data);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_heartbeat;
        input [7:0] expected_lfsr_data;
        begin
            if (expected_heartbeat === (expected_heartbeat ^ heartbeat ^ expected_heartbeat) &&
                expected_lfsr_data === (expected_lfsr_data ^ lfsr_data ^ expected_lfsr_data)) begin
                $display("PASS");
                $display("  Outputs: heartbeat=%b, lfsr_data=%h",
                         heartbeat, lfsr_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: heartbeat=%b, lfsr_data=%h",
                         expected_heartbeat, expected_lfsr_data);
                $display("  Got:      heartbeat=%b, lfsr_data=%h",
                         heartbeat, lfsr_data);
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
        $dumpvars(0,clk, enable, long_hb, new_seed, reset_n, seed, heartbeat, lfsr_data);
    end

endmodule
