`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] block_id;
    reg clk;
    reg req_alloc;
    reg req_free;
    reg [3:0] req_size;
    reg reset;
    wire [3:0] allocated_block;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .block_id(block_id),
        .clk(clk),
        .req_alloc(req_alloc),
        .req_free(req_free),
        .req_size(req_size),
        .reset(reset),
        .allocated_block(allocated_block),
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
            req_alloc = 0;
            req_free = 0;
            req_size = 0;
            block_id = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase%03d: Basic Allocation", test_num);
            reset_dut();

            req_alloc = 1;
            req_size = 4'd4;
            @(posedge clk);
            #1;
            req_alloc = 0;


            #1;



            check_outputs(allocated_block, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase%03d: Max Size Allocation", test_num);
            reset_dut();

            req_alloc = 1;
            req_size = 4'd15;
            @(posedge clk);
            #1;
            req_alloc = 0;


            #1;



            check_outputs(allocated_block, 1'b1);
        end
        endtask

    task testcase003;

        reg [3:0] last_id;
        begin
            test_num = 3;
            $display("\nRunning Testcase%03d: Allocate and Free", test_num);
            reset_dut();


            req_alloc = 1;
            req_size = 4'd2;
            @(posedge clk);
            #1 last_id = allocated_block;
            req_alloc = 0;
            @(posedge clk);


            req_free = 1;
            block_id = last_id;
            @(posedge clk);
            #1;
            req_free = 0;


            #1;



            check_outputs(allocated_block, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase%03d: Allocation Failure (Capacity)", test_num);
            reset_dut();


            req_alloc = 1;
            req_size = 4'd12;
            @(posedge clk);
            #1;
            req_alloc = 0;
            @(posedge clk);


            req_alloc = 1;
            req_size = 4'd8;
            @(posedge clk);
            #1;
            req_alloc = 0;


            #1;



            check_outputs(allocated_block, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase%03d: Free Invalid Block", test_num);
            reset_dut();

            req_free = 1;
            block_id = 4'hF;
            @(posedge clk);
            #1;
            req_free = 0;


            #1;



            check_outputs(allocated_block, 1'b0);
        end
        endtask

    task testcase006;

        reg [3:0] last_id;
        begin
            test_num = 6;
            $display("\nRunning Testcase%03d: Re-allocation after Free", test_num);
            reset_dut();


            req_alloc = 1;
            req_size = 4'd15;
            @(posedge clk);
            #1 last_id = allocated_block;
            req_alloc = 0;
            @(posedge clk);


            req_free = 1;
            block_id = last_id;
            @(posedge clk);
            #1 req_free = 0;
            @(posedge clk);


            req_alloc = 1;
            req_size = 4'd15;
            @(posedge clk);
            #1;
            req_alloc = 0;


            #1;



            check_outputs(allocated_block, 1'b1);
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
        input [3:0] expected_allocated_block;
        input expected_success;
        begin
            if (expected_allocated_block === (expected_allocated_block ^ allocated_block ^ expected_allocated_block) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: allocated_block=%h, success=%b",
                         allocated_block, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_block=%h, success=%b",
                         expected_allocated_block, expected_success);
                $display("  Got:      allocated_block=%h, success=%b",
                         allocated_block, success);
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
        $dumpvars(0,block_id, clk, req_alloc, req_free, req_size, reset, allocated_block, success);
    end

endmodule
