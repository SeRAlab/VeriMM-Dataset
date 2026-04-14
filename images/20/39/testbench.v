`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc;
    reg [3:0] block_num;
    reg clk;
    reg free;
    reg reset;
    wire [3:0] allocated_blocks;
    wire [15:0] memory_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc(alloc),
        .block_num(block_num),
        .clk(clk),
        .free(free),
        .reset(reset),
        .allocated_blocks(allocated_blocks),
        .memory_status(memory_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            alloc = 0;
            free = 0;
            block_num = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Allocation", test_num);
            reset_dut();

            block_num = 4'd5;
            alloc = 1;
            @(posedge clk);
            #1;
            alloc = 0;


            #1;



            check_outputs(4'd1, 16'h0020);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocate and Free", test_num);
            reset_dut();


            block_num = 4'd10;
            alloc = 1;
            @(posedge clk);
            #1;
            alloc = 0;


            free = 1;
            @(posedge clk);
            #1;
            free = 0;


            #1;



            check_outputs(4'd0, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Allocations", test_num);
            reset_dut();


            block_num = 4'd0;
            alloc = 1;
            @(posedge clk); #1;


            block_num = 4'd7;
            @(posedge clk); #1;


            block_num = 4'd15;
            @(posedge clk); #1;
            alloc = 0;


            #1;



            check_outputs(4'd3, 16'h8081);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Duplicate Allocation", test_num);
            reset_dut();

            block_num = 4'd2;
            alloc = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            alloc = 0;


            #1;



            check_outputs(4'd1, 16'h0004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Freeing Unallocated Block", test_num);
            reset_dut();

            block_num = 4'd8;
            free = 1;
            @(posedge clk); #1;
            free = 0;


            #1;



            check_outputs(4'd0, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Operations", test_num);
            reset_dut();


            alloc = 1;
            block_num = 4'd1; @(posedge clk); #1;
            block_num = 4'd2; @(posedge clk); #1;
            block_num = 4'd3; @(posedge clk); #1;
            alloc = 0;


            free = 1;
            block_num = 4'd2; @(posedge clk); #1;
            free = 0;


            alloc = 1;
            block_num = 4'd4; @(posedge clk); #1;
            alloc = 0;


            #1;



            check_outputs(4'd3, 16'h001A);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Filling 15 blocks", test_num);
            reset_dut();

            alloc = 1;
            for(i=0; i<15; i=i+1) begin
                block_num = i;
                @(posedge clk); #1;
            end
            alloc = 0;


            #1;



            check_outputs(4'hF, 16'h7FFF);
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
        input [3:0] expected_allocated_blocks;
        input [15:0] expected_memory_status;
        begin
            if (expected_allocated_blocks === (expected_allocated_blocks ^ allocated_blocks ^ expected_allocated_blocks) &&
                expected_memory_status === (expected_memory_status ^ memory_status ^ expected_memory_status)) begin
                $display("PASS");
                $display("  Outputs: allocated_blocks=%h, memory_status=%h",
                         allocated_blocks, memory_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_blocks=%h, memory_status=%h",
                         expected_allocated_blocks, expected_memory_status);
                $display("  Got:      allocated_blocks=%h, memory_status=%h",
                         allocated_blocks, memory_status);
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
        $dumpvars(0,alloc, block_num, clk, free, reset, allocated_blocks, memory_status);
    end

endmodule
