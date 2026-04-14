`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] free_index;
    reg req_alloc;
    reg req_free;
    reg [3:0] req_size;
    reg rst;
    wire alloc_success;
    wire free_success;
    wire [31:0] memory;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .clk(clk),
        .free_index(free_index),
        .req_alloc(req_alloc),
        .req_free(req_free),
        .req_size(req_size),
        .rst(rst),
        .alloc_success(alloc_success),
        .free_success(free_success),
        .memory(memory)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req_alloc = 0;
            req_free = 0;
            req_size = 0;
            free_index = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Test Case 001: Basic Allocation (Size 4)");
            req_alloc = 1;
            req_size = 4;
            @(posedge clk);
            req_alloc = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 32'h0000000F);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Test Case 002: Multiple Sequential Allocations");

            req_alloc = 1; req_size = 4;
            @(posedge clk);

            req_alloc = 1; req_size = 4;
            @(posedge clk);
            req_alloc = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 32'h000000FF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Test Case 003: Allocation Failure (Insufficient space)");

            req_alloc = 1; req_size = 15;
            @(posedge clk);

            req_alloc = 1; req_size = 15;
            @(posedge clk);

            req_alloc = 1; req_size = 5;
            @(posedge clk);
            req_alloc = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 32'h3FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Test Case 004: Basic Free Operation");

            req_alloc = 1; req_size = 8;
            @(posedge clk);
            req_alloc = 0;
            @(posedge clk);

            req_free = 1; free_index = 0;
            @(posedge clk);
            req_free = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Test Case 005: First-Fit Verification");

            req_alloc = 1; req_size = 4; @(posedge clk);

            req_alloc = 1; req_size = 4; @(posedge clk);

            req_alloc = 1; req_size = 4; @(posedge clk);
            req_alloc = 0;
            @(posedge clk);


            req_free = 1; free_index = 4; @(posedge clk);
            req_free = 0;
            @(posedge clk);


            req_alloc = 1; req_size = 2; @(posedge clk);
            req_alloc = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 32'h00000F3F);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Test Case 006: Max Size Allocation (15)");
            req_alloc = 1; req_size = 15;
            @(posedge clk);
            req_alloc = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0, 32'h00007FFF);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Test Case 007: Freeing Invalid Block");

            req_free = 1; free_index = 10;
            @(posedge clk);
            req_free = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 32'h00000000);
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
        input expected_alloc_success;
        input expected_free_success;
        input [31:0] expected_memory;
        begin
            if (expected_alloc_success === (expected_alloc_success ^ alloc_success ^ expected_alloc_success) &&
                expected_free_success === (expected_free_success ^ free_success ^ expected_free_success) &&
                expected_memory === (expected_memory ^ memory ^ expected_memory)) begin
                $display("PASS");
                $display("  Outputs: alloc_success=%b, free_success=%b, memory=%h",
                         alloc_success, free_success, memory);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_success=%b, free_success=%b, memory=%h",
                         expected_alloc_success, expected_free_success, expected_memory);
                $display("  Got:      alloc_success=%b, free_success=%b, memory=%h",
                         alloc_success, free_success, memory);
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
        $dumpvars(0,clk, free_index, req_alloc, req_free, req_size, rst, alloc_success, free_success, memory);
    end

endmodule
