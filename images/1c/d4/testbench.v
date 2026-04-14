`timescale 1ns/1ps

module memory_manager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg free;
    reg malloc;
    reg reset;
    wire [3:0] allocated_blocks;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_manager dut (
        .clk(clk),
        .free(free),
        .malloc(malloc),
        .reset(reset),
        .allocated_blocks(allocated_blocks)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            malloc = 0;
            free = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state...");
            reset_dut();
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Malloc...");
            reset_dut();
            malloc = 1;
            @(posedge clk);
            #1;
            malloc = 0;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Multiple Mallocs...");
            reset_dut();
            malloc = 1;
            repeat(3) @(posedge clk);
            #1;
            malloc = 0;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Malloc then Free...");
            reset_dut();
            malloc = 1;
            @(posedge clk);
            #1;
            malloc = 0;
            free = 1;
            @(posedge clk);
            #1;
            free = 0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Interleaved Malloc and Free...");
            reset_dut();

            malloc = 1;
            repeat(3) @(posedge clk);
            #1;
            malloc = 0;

            free = 1;
            @(posedge clk);
            #1;
            free = 0;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Freeing empty memory...");
            reset_dut();
            free = 1;
            @(posedge clk);
            #1;
            free = 0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Filling to capacity (15 blocks)...");
            reset_dut();
            malloc = 1;
            repeat(15) @(posedge clk);
            #1;
            malloc = 0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_manager Testbench");
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
        input [3:0] expected_allocated_blocks;
        begin
            if (expected_allocated_blocks === (expected_allocated_blocks ^ allocated_blocks ^ expected_allocated_blocks)) begin
                $display("PASS");
                $display("  Outputs: allocated_blocks=%h",
                         allocated_blocks);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_blocks=%h",
                         expected_allocated_blocks);
                $display("  Got:      allocated_blocks=%h",
                         allocated_blocks);
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
        $dumpvars(0,clk, free, malloc, reset, allocated_blocks);
    end

endmodule
