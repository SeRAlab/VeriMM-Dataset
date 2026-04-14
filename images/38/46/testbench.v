`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg alloc;
    reg clk;
    reg free;
    wire allocated;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .addr(addr),
        .alloc(alloc),
        .clk(clk),
        .free(free),
        .allocated(allocated),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 3'b000;
            alloc = 1'b0;
            free = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: Allocate Block 0...");
            reset_dut();
            addr = 3'd0;
            alloc = 1'b1;
            @(posedge clk);
            #1;
            alloc = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Allocate Block 7...");
            reset_dut();
            addr = 3'd7;
            alloc = 1'b1;
            @(posedge clk);
            #1;
            alloc = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: Allocate then Free Block 2...");
            reset_dut();

            addr = 3'd2;
            alloc = 1'b1;
            @(posedge clk);
            #1;
            alloc = 1'b0;

            free = 1'b1;
            @(posedge clk);
            #1;
            free = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Check Unallocated Block 4...");
            reset_dut();
            addr = 3'd4;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: Allocate Block 1, check Block 5...");
            reset_dut();

            addr = 3'd1;
            alloc = 1'b1;
            @(posedge clk);
            #1;
            alloc = 1'b0;

            addr = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase006: Multiple allocs, free one, check remaining...");
            reset_dut();

            addr = 3'd3;
            alloc = 1'b1;
            @(posedge clk);
            #1;

            addr = 3'd6;
            alloc = 1'b1;
            @(posedge clk);
            #1;
            alloc = 1'b0;

            addr = 3'd3;
            free = 1'b1;
            @(posedge clk);
            #1;
            free = 1'b0;

            addr = 3'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_allocator Testbench");
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
        input expected_allocated;
        input [3:0] expected_data_out;
        begin
            if (expected_allocated === (expected_allocated ^ allocated ^ expected_allocated) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: allocated=%b, data_out=%h",
                         allocated, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated=%b, data_out=%h",
                         expected_allocated, expected_data_out);
                $display("  Got:      allocated=%b, data_out=%h",
                         allocated, data_out);
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
        $dumpvars(0,addr, alloc, clk, free, allocated, data_out);
    end

endmodule
