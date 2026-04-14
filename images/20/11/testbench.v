`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] alloc_index;
    reg allocate;
    reg clk;
    reg free;
    reg [3:0] free_index;
    reg reset;
    wire [7:0] memory_status;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .alloc_index(alloc_index),
        .allocate(allocate),
        .clk(clk),
        .free(free),
        .free_index(free_index),
        .reset(reset),
        .memory_status(memory_status),
        .success(success)
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
            alloc_index = 0;
            free_index = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Allocation", test_num);
            reset_dut();

            alloc_index = 4'd3;
            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;


            #1;



            check_outputs(8'h08, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Double Allocation Failure", test_num);
            reset_dut();


            alloc_index = 4'd0;
            allocate = 1;
            @(posedge clk);


            alloc_index = 4'd0;
            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;


            #1;



            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Basic Freeing", test_num);
            reset_dut();


            alloc_index = 4'd7;
            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;


            free_index = 4'd7;
            free = 1;
            @(posedge clk);
            #1 free = 0;


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Invalid Freeing", test_num);
            reset_dut();

            free_index = 4'd5;
            free = 1;
            @(posedge clk);
            #1 free = 0;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multiple Sequential Allocations", test_num);
            reset_dut();


            allocate = 1;
            alloc_index = 4'd0; @(posedge clk);
            alloc_index = 4'd2; @(posedge clk);
            alloc_index = 4'd4; @(posedge clk);
            alloc_index = 4'd6; @(posedge clk);
            #1 allocate = 0;


            #1;



            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Out-of-Bounds Indexing", test_num);
            reset_dut();

            alloc_index = 4'd12;
            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;


            #1;



            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_memory_status;
        input expected_success;
        begin
            if (expected_memory_status === (expected_memory_status ^ memory_status ^ expected_memory_status) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: memory_status=%h, success=%b",
                         memory_status, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_status=%h, success=%b",
                         expected_memory_status, expected_success);
                $display("  Got:      memory_status=%h, success=%b",
                         memory_status, success);
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
        $dumpvars(0,alloc_index, allocate, clk, free, free_index, reset, memory_status, success);
    end

endmodule
