`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg FAST;
    reg [2:0] MODE;
    reg RESET;
    wire [7:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .FAST(FAST),
        .MODE(MODE),
        .RESET(RESET),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            RESET = 1;
            FAST = 0;
            MODE = 0;
            @(posedge CLOCK);
            #1 RESET = 0;
            @(posedge CLOCK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            FAST = 1;
            MODE = 3'd1;

            repeat(10) @(posedge CLOCK);
            #2 #1;
 check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            FAST = 1;
            MODE = 3'd7;
            repeat(10) @(posedge CLOCK);
            #2 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            FAST = 0;
            MODE = 3'd4;
            repeat(100) @(posedge CLOCK);
            #2 #1;
 check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            FAST = 1;
            MODE = 3'd5;

            repeat(5) @(posedge CLOCK);
            #2 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            FAST = 1;
            MODE = 3'd0;
            repeat(10) @(posedge CLOCK);
            #2 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            FAST = 0;
            MODE = 3'd6;
            repeat(100) @(posedge CLOCK);
            #2 #1;
 check_outputs(8'h3F);
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
        input [7:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,CLOCK, FAST, MODE, RESET, LED);
    end

endmodule
