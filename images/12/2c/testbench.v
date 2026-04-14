`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] alloc_request;
    reg clk;
    reg [3:0] free_slot;
    reg rst;
    wire [15:0] memory;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .alloc_request(alloc_request),
        .clk(clk),
        .free_slot(free_slot),
        .rst(rst),
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
        alloc_request = 0;
        free_slot = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Allocation", test_num);
        reset_dut();

        alloc_request = 4'd1;
        free_slot = 4'd15;
        @(posedge clk);

        #1 #1;
 check_outputs(16'h0002);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Allocations", test_num);
        reset_dut();


        alloc_request = 4'd0;
        free_slot = 4'hf;
        @(posedge clk);


        alloc_request = 4'd4;
        @(posedge clk);


        alloc_request = 4'd8;
        @(posedge clk);


        alloc_request = 4'd12;
        @(posedge clk);

        #1 #1;
 check_outputs(16'h1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Allocate and Free", test_num);
        reset_dut();


        alloc_request = 4'd5;
        free_slot = 4'd0;
        @(posedge clk);


        alloc_request = 4'd0;
        free_slot = 4'd5;
        @(posedge clk);

        #1 #1;
 check_outputs(16'h0001);
    end
        endtask

    task testcase004;

        integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Fill All Slots", test_num);
        reset_dut();

        for (i = 0; i < 16; i = i + 1) begin
            alloc_request = i;
            free_slot = 4'hf;
            if (i == 15) free_slot = 4'd0;
            @(posedge clk);
        end

        #1 #1;
 check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Free Unallocated", test_num);
        reset_dut();


        alloc_request = 4'd10;
        free_slot = 4'd0;
        @(posedge clk);


        alloc_request = 4'd10;
        free_slot = 4'd2;
        @(posedge clk);

        #1 #1;
 check_outputs(16'h0400);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Override", test_num);
        reset_dut();

        alloc_request = 4'd7;
        @(posedge clk);

        rst = 1;
        alloc_request = 4'd3;
        @(posedge clk);

        rst = 0;
        #1 #1;
 check_outputs(16'h0000);
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
        input [15:0] expected_memory;
        begin
            if (expected_memory === (expected_memory ^ memory ^ expected_memory)) begin
                $display("PASS");
                $display("  Outputs: memory=%h",
                         memory);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory=%h",
                         expected_memory);
                $display("  Got:      memory=%h",
                         memory);
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
        $dumpvars(0,alloc_request, clk, free_slot, rst, memory);
    end

endmodule
