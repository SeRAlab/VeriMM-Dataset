`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc_req;
    reg [31:0] alloc_size;
    reg clk;
    reg free_req;
    reg rst;
    wire [31:0] allocated_memory;
    wire [31:0] free_memory;
    wire [31:0] total_memory;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .alloc_req(alloc_req),
        .alloc_size(alloc_size),
        .clk(clk),
        .free_req(free_req),
        .rst(rst),
        .allocated_memory(allocated_memory),
        .free_memory(free_memory),
        .total_memory(total_memory)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            alloc_req = 0;
            free_req = 0;
            alloc_size = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(32'd0, 32'd1024, 32'd1024);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Allocation", test_num);
            reset_dut();
            @(posedge clk);
            alloc_req = 1;
            alloc_size = 32'd256;
            @(posedge clk);
            alloc_req = 0;
            alloc_size = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'd256, 32'd768, 32'd1024);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Allocations", test_num);
            reset_dut();

            @(posedge clk);
            alloc_req = 1;
            alloc_size = 32'd100;
            @(posedge clk);

            alloc_req = 1;
            alloc_size = 32'd150;
            @(posedge clk);
            alloc_req = 0;
            alloc_size = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'd250, 32'd774, 32'd1024);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocation and Deallocation", test_num);
            reset_dut();

            @(posedge clk);
            alloc_req = 1;
            alloc_size = 32'd500;
            @(posedge clk);
            alloc_req = 0;

            free_req = 1;
            alloc_size = 32'd200;
            @(posedge clk);
            free_req = 0;
            alloc_size = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'd300, 32'd724, 32'd1024);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Memory Allocation", test_num);
            reset_dut();
            @(posedge clk);
            alloc_req = 1;
            alloc_size = 32'd1024;
            @(posedge clk);
            alloc_req = 0;
            alloc_size = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'd1024, 32'd0, 32'd1024);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Handling", test_num);
            reset_dut();
            @(posedge clk);
            alloc_req = 1;
            alloc_size = 32'd2048;
            @(posedge clk);
            alloc_req = 0;
            alloc_size = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'd0, 32'd1024, 32'd1024);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow Handling", test_num);
            reset_dut();

            @(posedge clk);
            alloc_req = 1;
            alloc_size = 32'd100;
            @(posedge clk);
            alloc_req = 0;

            free_req = 1;
            alloc_size = 32'd200;
            @(posedge clk);
            free_req = 0;
            alloc_size = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'd0, 32'd1024, 32'd1024);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MemoryAllocator Testbench");
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
        input [31:0] expected_allocated_memory;
        input [31:0] expected_free_memory;
        input [31:0] expected_total_memory;
        begin
            if (expected_allocated_memory === (expected_allocated_memory ^ allocated_memory ^ expected_allocated_memory) &&
                expected_free_memory === (expected_free_memory ^ free_memory ^ expected_free_memory) &&
                expected_total_memory === (expected_total_memory ^ total_memory ^ expected_total_memory)) begin
                $display("PASS");
                $display("  Outputs: allocated_memory=%h, free_memory=%h, total_memory=%h",
                         allocated_memory, free_memory, total_memory);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_memory=%h, free_memory=%h, total_memory=%h",
                         expected_allocated_memory, expected_free_memory, expected_total_memory);
                $display("  Got:      allocated_memory=%h, free_memory=%h, total_memory=%h",
                         allocated_memory, free_memory, total_memory);
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
        $dumpvars(0,alloc_req, alloc_size, clk, free_req, rst, allocated_memory, free_memory, total_memory);
    end

endmodule
