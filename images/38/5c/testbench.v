`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg [3:0] block_index;
    reg clk;
    reg free;
    reg [3:0] request_size;
    reg reset;
    wire [15:0] allocated;
    wire allocation_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .block_index(block_index),
        .clk(clk),
        .free(free),
        .request_size(request_size),
        .reset(reset),
        .allocated(allocated),
        .allocation_success(allocation_success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            allocate = 0;
            free = 0;
            block_index = 0;
            request_size = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Allocation (Size 4)");
            reset_dut();
            request_size = 4;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h000F, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Multiple Allocations");
            reset_dut();


            request_size = 8;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            repeat(2) @(posedge clk);


            request_size = 8;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Allocation Size Overflow");
            reset_dut();


            request_size = 4'd17;



            request_size = 12;
            allocate = 1; @(posedge clk); allocate = 0;
            repeat(2) @(posedge clk);


            request_size = 8;
            allocate = 1; @(posedge clk); allocate = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h0FFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Deallocation (Free)");
            reset_dut();


            request_size = 4;
            allocate = 1; @(posedge clk); allocate = 0;
            repeat(2) @(posedge clk);


            block_index = 0;
            free = 1;
            @(posedge clk);
            free = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Free and Reallocate");
            reset_dut();


            request_size = 8;
            allocate = 1; @(posedge clk); allocate = 0;
            repeat(2) @(posedge clk);


            block_index = 0;
            free = 1; @(posedge clk); free = 0;
            repeat(2) @(posedge clk);


            request_size = 4;
            allocate = 1; @(posedge clk); allocate = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h000F, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Fragmentation/Complex State");
            reset_dut();


            request_size = 4;
            allocate = 1; @(posedge clk); allocate = 0;
            repeat(2) @(posedge clk);


            request_size = 4;
            allocate = 1; @(posedge clk); allocate = 0;
            repeat(2) @(posedge clk);


            block_index = 0;
            free = 1; @(posedge clk); free = 0;
            repeat(2) @(posedge clk);



            request_size = 4;
            allocate = 1; @(posedge clk); allocate = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h00FF, 1'b1);
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
        input [15:0] expected_allocated;
        input expected_allocation_success;
        begin
            if (expected_allocated === (expected_allocated ^ allocated ^ expected_allocated) &&
                expected_allocation_success === (expected_allocation_success ^ allocation_success ^ expected_allocation_success)) begin
                $display("PASS");
                $display("  Outputs: allocated=%h, allocation_success=%b",
                         allocated, allocation_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated=%h, allocation_success=%b",
                         expected_allocated, expected_allocation_success);
                $display("  Got:      allocated=%h, allocation_success=%b",
                         allocated, allocation_success);
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
        $dumpvars(0,allocate, block_index, clk, free, request_size, reset, allocated, allocation_success);
    end

endmodule
