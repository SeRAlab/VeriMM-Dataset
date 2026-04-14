`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg [1:0] block_id;
    reg clk;
    reg free;
    reg [2:0] req_size;
    reg reset;
    wire [3:0] status;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .allocate(allocate),
        .block_id(block_id),
        .clk(clk),
        .free(free),
        .req_size(req_size),
        .reset(reset),
        .status(status),
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
            block_id = 0;
            req_size = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Allocation");
            reset_dut();
            test_num = test_num + 1;

            allocate = 1;
            block_id = 0;
            req_size = 3;
            @(posedge clk);
            #1 allocate = 0;



            #1;




            check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Allocate and Free");
            reset_dut();
            test_num = test_num + 1;


            allocate = 1;
            block_id = 1;
            req_size = 5;
            @(posedge clk);
            #1 allocate = 0;
            @(posedge clk);


            free = 1;
            block_id = 1;
            @(posedge clk);
            #1 free = 0;



            #1;




            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Multiple Block Allocation");
            reset_dut();
            test_num = test_num + 1;


            allocate = 1;
            block_id = 0;
            req_size = 2;
            @(posedge clk);
            #1 allocate = 0;
            @(posedge clk);


            allocate = 1;
            block_id = 2;
            req_size = 4;
            @(posedge clk);
            #1 allocate = 0;



            #1;




            check_outputs(4'b1100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Max Size Allocation");
            reset_dut();
            test_num = test_num + 1;

            allocate = 1;
            block_id = 3;
            req_size = 7;
            @(posedge clk);
            #1 allocate = 0;


            #1;



            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Double Allocation Conflict");
            reset_dut();
            test_num = test_num + 1;


            allocate = 1;
            block_id = 0;
            req_size = 2;
            @(posedge clk);
            #1 allocate = 0;
            @(posedge clk);


            allocate = 1;
            block_id = 0;
            req_size = 6;
            @(posedge clk);
            #1 allocate = 0;




            #1;





            check_outputs(4'b1010, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Free Unallocated Block");
            reset_dut();
            test_num = test_num + 1;

            free = 1;
            block_id = 2;
            @(posedge clk);
            #1 free = 0;


            #1;



            check_outputs(4'b0000, 1'b0);
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
        input [3:0] expected_status;
        input expected_success;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: status=%h, success=%b",
                         status, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h, success=%b",
                         expected_status, expected_success);
                $display("  Got:      status=%h, success=%b",
                         status, success);
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
        $dumpvars(0,allocate, block_id, clk, free, req_size, reset, status, success);
    end

endmodule
