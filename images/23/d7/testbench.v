`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] free_address;
    reg free_req;
    reg malloc_req;
    reg [3:0] malloc_size;
    reg rst;
    wire alloc_success;
    wire [3:0] allocated_address;
    wire free_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .clk(clk),
        .free_address(free_address),
        .free_req(free_req),
        .malloc_req(malloc_req),
        .malloc_size(malloc_size),
        .rst(rst),
        .alloc_success(alloc_success),
        .allocated_address(allocated_address),
        .free_success(free_success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            malloc_req = 0;
            malloc_size = 0;
            free_req = 0;
            free_address = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Allocation", test_num);
            reset_dut();

            malloc_req = 1;
            malloc_size = 4;
            @(posedge clk);
            #1 malloc_req = 0;


            #1;



            check_outputs(1'b1, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Memory Full Condition", test_num);
            reset_dut();


            malloc_req = 1;
            malloc_size = 12;
            @(posedge clk);
            #1;


            malloc_size = 8;
            @(posedge clk);
            #1 malloc_req = 0;


            #1;



            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Free and Re-allocate", test_num);
            reset_dut();


            malloc_req = 1;
            malloc_size = 4;
            @(posedge clk);
            #1 malloc_req = 0;


            free_req = 1;
            free_address = 4'h0;
            @(posedge clk);
            #1 free_req = 0;


            malloc_req = 1;
            malloc_size = 4;
            @(posedge clk);
            #1 malloc_req = 0;


            #1;



            check_outputs(1'b1, 4'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Invalid Free Operation", test_num);
            reset_dut();


            free_req = 1;
            free_address = 4'h8;
            @(posedge clk);
            #1 free_req = 0;


            #1;



            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Size Allocation", test_num);
            reset_dut();

            malloc_req = 1;
            malloc_size = 15;
            @(posedge clk);
            #1 malloc_req = 0;


            #1;



            check_outputs(1'b1, 4'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fragmentation Handling", test_num);
            reset_dut();


            malloc_req = 1; malloc_size = 4; @(posedge clk); #1;

            malloc_size = 4; @(posedge clk); #1;

            malloc_req = 0; free_req = 1; free_address = 4'h0; @(posedge clk); #1;

            free_req = 0; malloc_req = 1; malloc_size = 2; @(posedge clk); #1;
            malloc_req = 0;


            #1;



            check_outputs(1'b1, 4'h0, 1'b1);
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
        input expected_alloc_success;
        input [3:0] expected_allocated_address;
        input expected_free_success;
        begin
            if (expected_alloc_success === (expected_alloc_success ^ alloc_success ^ expected_alloc_success) &&
                expected_allocated_address === (expected_allocated_address ^ allocated_address ^ expected_allocated_address) &&
                expected_free_success === (expected_free_success ^ free_success ^ expected_free_success)) begin
                $display("PASS");
                $display("  Outputs: alloc_success=%b, allocated_address=%h, free_success=%b",
                         alloc_success, allocated_address, free_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_success=%b, allocated_address=%h, free_success=%b",
                         expected_alloc_success, expected_allocated_address, expected_free_success);
                $display("  Got:      alloc_success=%b, allocated_address=%h, free_success=%b",
                         alloc_success, allocated_address, free_success);
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
        $dumpvars(0,clk, free_address, free_req, malloc_req, malloc_size, rst, alloc_success, allocated_address, free_success);
    end

endmodule
