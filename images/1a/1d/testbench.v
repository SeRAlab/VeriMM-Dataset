`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc;
    reg [2:0] block_id;
    reg clk;
    reg free;
    reg rst;
    wire allocated;
    wire freed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc(alloc),
        .block_id(block_id),
        .clk(clk),
        .free(free),
        .rst(rst),
        .allocated(allocated),
        .freed(freed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            alloc = 0;
            free = 0;
            block_id = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocate block 0 (Expected: Success)", test_num);
            reset_dut();

            block_id = 3'd0;
            alloc = 1;
            @(posedge clk);
            #1;
            alloc = 0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Free block 1 without allocation (Expected: Failure)", test_num);
            reset_dut();

            block_id = 3'd1;
            free = 1;
            @(posedge clk);
            #1;
            free = 0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocate then free block 2 (Expected: Success)", test_num);
            reset_dut();


            block_id = 3'd2;
            alloc = 1;
            @(posedge clk);
            #1;
            alloc = 0;


            free = 1;
            @(posedge clk);
            #1;
            free = 0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Re-allocate block 3 (Expected: Failure)", test_num);
            reset_dut();


            block_id = 3'd3;
            alloc = 1;
            @(posedge clk);
            #1;


            alloc = 1;
            @(posedge clk);
            #1;
            alloc = 0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Re-free block 4 (Expected: Failure)", test_num);
            reset_dut();


            block_id = 3'd4;
            alloc = 1;
            @(posedge clk);
            #1;
            alloc = 0;


            free = 1;
            @(posedge clk);
            #1;


            free = 1;
            @(posedge clk);
            #1;
            free = 0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocate block 7 (Expected: Success)", test_num);
            reset_dut();

            block_id = 3'd7;
            alloc = 1;
            @(posedge clk);
            #1;
            alloc = 0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interleaved operations (Expected: Success)", test_num);
            reset_dut();


            block_id = 3'd0;
            alloc = 1;
            @(posedge clk);
            #1;


            block_id = 3'd5;
            alloc = 1;
            @(posedge clk);
            #1;


            alloc = 0;
            block_id = 3'd0;
            free = 1;
            @(posedge clk);
            #1;
            free = 0;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_allocated;
        input expected_freed;
        begin
            if (expected_allocated === (expected_allocated ^ allocated ^ expected_allocated) &&
                expected_freed === (expected_freed ^ freed ^ expected_freed)) begin
                $display("PASS");
                $display("  Outputs: allocated=%b, freed=%b",
                         allocated, freed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated=%b, freed=%b",
                         expected_allocated, expected_freed);
                $display("  Got:      allocated=%b, freed=%b",
                         allocated, freed);
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
        $dumpvars(0,alloc, block_id, clk, free, rst, allocated, freed);
    end

endmodule
