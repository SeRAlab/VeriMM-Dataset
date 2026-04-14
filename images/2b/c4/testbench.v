`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc;
    reg [2:0] block_index;
    reg clk;
    reg free;
    reg [5:0] request_size;
    reg rst;
    wire [5:0] address;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .alloc(alloc),
        .block_index(block_index),
        .clk(clk),
        .free(free),
        .request_size(request_size),
        .rst(rst),
        .address(address),
        .success(success)
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
            free = 0;
            request_size = 0;
            block_index = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Allocation", test_num);


            request_size = 16;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;



            #1;




            check_outputs(6'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Sequential Allocations", test_num);


            request_size = 10;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;
            @(posedge clk);


            request_size = 20;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;


            #1;



            check_outputs(6'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Allocation Failure - Out of Range", test_num);


            request_size = 65;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;


            #1;



            check_outputs(address, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Free and Re-allocate", test_num);


            request_size = 32;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;
            @(posedge clk);


            block_index = 0;
            free = 1;
            @(posedge clk);
            #1 free = 0;
            @(posedge clk);


            request_size = 32;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;


            #1;



            check_outputs(6'd0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Block Limit", test_num);


            for (i = 0; i < 8; i = i + 1) begin
                request_size = 2;
                alloc = 1;
                @(posedge clk);
                #1 alloc = 0;
                @(posedge clk);
            end


            request_size = 2;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;

            #1;


            check_outputs(address, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Fragmentation Check", test_num);


            request_size = 10; alloc = 1; @(posedge clk); #1 alloc = 0; @(posedge clk);

            request_size = 10; alloc = 1; @(posedge clk); #1 alloc = 0; @(posedge clk);

            block_index = 0; free = 1; @(posedge clk); #1 free = 0; @(posedge clk);

            request_size = 10; alloc = 1; @(posedge clk); #1 alloc = 0;

            #1;


            check_outputs(6'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Freeing Empty Slot", test_num);


            block_index = 5;
            free = 1;
            @(posedge clk);
            #1 free = 0;


            #1;



            check_outputs(address, 1'b0);
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
        input [5:0] expected_address;
        input expected_success;
        begin
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: address=%h, success=%b",
                         address, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, success=%b",
                         expected_address, expected_success);
                $display("  Got:      address=%h, success=%b",
                         address, success);
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
        $dumpvars(0,alloc, block_index, clk, free, request_size, rst, address, success);
    end

endmodule
