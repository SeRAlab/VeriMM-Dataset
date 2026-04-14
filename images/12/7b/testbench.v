`timescale 1ns/1ps

module CacheReplacementPolicy_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] access_address;
    reg clk;
    reg reset;
    reg use_LRU;
    wire [3:0] cache_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CacheReplacementPolicy dut (
        .access_address(access_address),
        .clk(clk),
        .reset(reset),
        .use_LRU(use_LRU),
        .cache_state(cache_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            access_address = 4'h0;
            use_LRU = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: FIFO basic sequence...");
            reset_dut();
            use_LRU = 0;
            access_address = 4'hA; @(posedge clk); #1;
            access_address = 4'hB; @(posedge clk); #1;
            access_address = 4'hC; @(posedge clk); #1;
            access_address = 4'hD; @(posedge clk); #1;

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: LRU with hit...");
            reset_dut();
            use_LRU = 1;
            access_address = 4'h1; @(posedge clk); #1;
            access_address = 4'h2; @(posedge clk); #1;
            access_address = 4'h1; @(posedge clk); #1;
            access_address = 4'h3; @(posedge clk); #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Policy switching...");
            reset_dut();
            use_LRU = 0;
            access_address = 4'h5; @(posedge clk); #1;
            access_address = 4'h6; @(posedge clk); #1;
            use_LRU = 1;
            access_address = 4'h5; @(posedge clk); #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Reset during operation...");
            reset_dut();
            access_address = 4'hF; @(posedge clk); #1;
            access_address = 4'hE; @(posedge clk); #1;
            reset = 1;             @(posedge clk); #1;
            reset = 0;             @(posedge clk); #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Repeated access...");
            reset_dut();
            use_LRU = 1;
            access_address = 4'h7; @(posedge clk); #1;
            access_address = 4'h7; @(posedge clk); #1;
            access_address = 4'h7; @(posedge clk); #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CacheReplacementPolicy Testbench");
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
        input [3:0] expected_cache_state;
        begin
            if (expected_cache_state === (expected_cache_state ^ cache_state ^ expected_cache_state)) begin
                $display("PASS");
                $display("  Outputs: cache_state=%h",
                         cache_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cache_state=%h",
                         expected_cache_state);
                $display("  Got:      cache_state=%h",
                         cache_state);
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
        $dumpvars(0,access_address, clk, reset, use_LRU, cache_state);
    end

endmodule
