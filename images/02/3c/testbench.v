`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc_req;
    reg [7:0] alloc_size;
    reg clk;
    reg free_req;
    reg [7:0] free_size;
    reg reset;
    wire [7:0] allocated_memory;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc_req(alloc_req),
        .alloc_size(alloc_size),
        .clk(clk),
        .free_req(free_req),
        .free_size(free_size),
        .reset(reset),
        .allocated_memory(allocated_memory)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            alloc_req = 0;
            alloc_size = 0;
            free_req = 0;
            free_size = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Simple allocation...");
            reset_dut();
            @(posedge clk);
            alloc_req = 1;
            alloc_size = 8'd20;
            @(posedge clk);
            alloc_req = 0;
            alloc_size = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple allocations...");
            reset_dut();
            @(posedge clk);

            alloc_req = 1;
            alloc_size = 8'd10;
            @(posedge clk);

            alloc_req = 1;
            alloc_size = 8'd15;
            @(posedge clk);
            alloc_req = 0;
            alloc_size = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Allocate and then free...");
            reset_dut();
            @(posedge clk);

            alloc_req = 1;
            alloc_size = 8'd50;
            @(posedge clk);
            alloc_req = 0;

            free_req = 1;
            free_size = 8'd20;
            @(posedge clk);
            free_req = 0;
            free_size = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Allocate multiple and free all...");
            reset_dut();
            @(posedge clk);

            alloc_req = 1;
            alloc_size = 8'd30;
            @(posedge clk);

            alloc_req = 1;
            alloc_size = 8'd40;
            @(posedge clk);
            alloc_req = 0;

            free_req = 1;
            free_size = 8'd70;
            @(posedge clk);
            free_req = 0;
            free_size = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Interleaved allocate and free...");
            reset_dut();
            @(posedge clk);

            alloc_req = 1;
            alloc_size = 8'd100;
            @(posedge clk);


            alloc_req = 1;
            alloc_size = 8'd10;
            free_req = 1;
            free_size = 8'd40;
            @(posedge clk);
            alloc_req = 0;
            free_req = 0;
            repeat (2) @(posedge clk);

            #1;


            check_outputs(8'd70);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Capacity boundary test...");
            reset_dut();
            @(posedge clk);
            alloc_req = 1;
            alloc_size = 8'd255;
            @(posedge clk);
            alloc_req = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(8'd255);
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
        input [7:0] expected_allocated_memory;
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
        $dumpvars(0,alloc_req, alloc_size, clk, free_req, free_size, reset, allocated_memory);
    end

endmodule
