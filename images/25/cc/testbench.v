`timescale 1ns/1ps

module memory_manager_tb;

    // Testbench signals (sequential circuit)
    reg alloc;
    reg [9:0] allocate_size;
    reg clk;
    reg free;
    reg [9:0] free_address;
    reg rst;
    wire [10:0] free_memory;
    wire [10:0] used_memory;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_manager dut (
        .alloc(alloc),
        .allocate_size(allocate_size),
        .clk(clk),
        .free(free),
        .free_address(free_address),
        .rst(rst),
        .free_memory(free_memory),
        .used_memory(used_memory)
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
            allocate_size = 0;
            free = 0;
            free_address = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(11'd1024, 11'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Allocation (128 bytes)", test_num);
            reset_dut();

            alloc = 1;
            allocate_size = 10'd128;
            @(posedge clk);
            #1 alloc = 0;
            allocate_size = 0;
            @(posedge clk);


            #1;



            check_outputs(11'd896, 11'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple Sequential Allocations", test_num);
            reset_dut();


            alloc = 1;
            allocate_size = 10'd200;
            @(posedge clk);
            #1;


            alloc = 1;
            allocate_size = 10'd300;
            @(posedge clk);
            #1 alloc = 0;
            allocate_size = 0;
            @(posedge clk);


            #1;



            check_outputs(11'd524, 11'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Allocate and Free", test_num);
            reset_dut();


            alloc = 1;
            allocate_size = 10'd512;
            @(posedge clk);
            #1 alloc = 0;
            @(posedge clk);


            free = 1;
            free_address = 10'd0;
            @(posedge clk);
            #1 free = 0;
            @(posedge clk);


            #1;



            check_outputs(11'd1024, 11'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Full Memory Allocation", test_num);
            reset_dut();

            alloc = 1;
            allocate_size = 10'd1024;
            @(posedge clk);
            #1 alloc = 0;
            @(posedge clk);


            #1;



            check_outputs(11'd0, 11'd1024);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Over-allocation Attempt", test_num);
            reset_dut();


            alloc = 1;
            allocate_size = 10'd1024;
            @(posedge clk);
            #1;


            alloc = 1;
            allocate_size = 10'd1;
            @(posedge clk);
            #1 alloc = 0;
            @(posedge clk);


            #1;



            check_outputs(11'd0, 11'd1024);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Interleaved Alloc and Free", test_num);
            reset_dut();


            alloc = 1; allocate_size = 10'd200;
            @(posedge clk); #1;

            alloc = 1; allocate_size = 10'd300;
            @(posedge clk); #1;


            alloc = 0; free = 1; free_address = 10'd0;
            @(posedge clk); #1 free = 0;
            @(posedge clk);


            #1;



            check_outputs(11'd724, 11'd300);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_manager Testbench");
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
        input [10:0] expected_free_memory;
        input [10:0] expected_used_memory;
        begin
            if (expected_free_memory === (expected_free_memory ^ free_memory ^ expected_free_memory) &&
                expected_used_memory === (expected_used_memory ^ used_memory ^ expected_used_memory)) begin
                $display("PASS");
                $display("  Outputs: free_memory=%h, used_memory=%h",
                         free_memory, used_memory);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: free_memory=%h, used_memory=%h",
                         expected_free_memory, expected_used_memory);
                $display("  Got:      free_memory=%h, used_memory=%h",
                         free_memory, used_memory);
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
        $dumpvars(0,alloc, allocate_size, clk, free, free_address, rst, free_memory, used_memory);
    end

endmodule
