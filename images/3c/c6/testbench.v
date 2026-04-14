`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg clk;
    reg free;
    reg [3:0] free_size;
    reg [3:0] request_size;
    reg rst;
    wire [15:0] allocated_memory;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .clk(clk),
        .free(free),
        .free_size(free_size),
        .request_size(request_size),
        .rst(rst),
        .allocated_memory(allocated_memory)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            allocate = 0;
            free = 0;
            request_size = 0;
            free_size = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Simple Allocation (Size 4)");
            test_num = 2;
            reset_dut();
            request_size = 4;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);

            #1;


            check_outputs(16'h000F);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Sequential Allocations (4 then 4)");
            test_num = 3;
            reset_dut();

            request_size = 4;
            allocate = 1;
            @(posedge clk);

            request_size = 4;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);

            #1;


            check_outputs(16'h00FF);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: FIFO Deallocation (Alloc 8, Free 4)");
            test_num = 4;
            reset_dut();

            request_size = 8;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);

            free_size = 4;
            free = 1;
            @(posedge clk);
            free = 0;
            @(posedge clk);

            #1;


            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Full Memory Allocation (Size 16)");
            test_num = 5;
            reset_dut();
            request_size = 15;
            allocate = 1;
            @(posedge clk);
            request_size = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Complete Clear (Alloc 12, Free 12)");
            test_num = 6;
            reset_dut();
            request_size = 12;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);
            free_size = 12;
            free = 1;
            @(posedge clk);
            free = 0;
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Pointer Wrap-around (Alloc 4, Free 2, Alloc 6)");
            test_num = 7;
            reset_dut();

            request_size = 4;
            allocate = 1;
            @(posedge clk);

            allocate = 0;
            free_size = 2;
            free = 1;
            @(posedge clk);

            free = 0;
            request_size = 6;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);

            #1;


            check_outputs(16'h03FC);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Interleaved Ops (Alloc 16, Free 8, Alloc 4)");
            test_num = 8;
            reset_dut();

            request_size = 15;
            allocate = 1;
            @(posedge clk);
            request_size = 1;
            @(posedge clk);

            allocate = 0;
            free_size = 8;
            free = 1;
            @(posedge clk);

            free = 0;
            request_size = 4;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);


            #1;



            check_outputs(16'hFF0F);
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
        testcase008();
        
        
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
        input [15:0] expected_allocated_memory;
        begin
            if (expected_allocated_memory === (expected_allocated_memory ^ allocated_memory ^ expected_allocated_memory)) begin
                $display("PASS");
                $display("  Outputs: allocated_memory=%h",
                         allocated_memory);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_memory=%h",
                         expected_allocated_memory);
                $display("  Got:      allocated_memory=%h",
                         allocated_memory);
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
        $dumpvars(0,allocate, clk, free, free_size, request_size, rst, allocated_memory);
    end

endmodule
