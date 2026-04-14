`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] block_id;
    reg clk;
    reg req_alloc;
    reg req_free;
    reg rst;
    wire [15:0] bitmap;
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
        .rst(rst),
        .bitmap(bitmap),
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
            req_alloc = 0;
            req_free = 0;
            block_id = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Allocate block 0", test_num);
            reset_dut();
            block_id = 4'd0;
            req_alloc = 1;
            @(posedge clk);
            #1 req_alloc = 0;
            #1;

            check_outputs(16'h0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Allocate block 5", test_num);
            reset_dut();
            block_id = 4'd5;
            req_alloc = 1;
            @(posedge clk);
            #1 req_alloc = 0;
            #1;

            check_outputs(16'h0020, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Double allocation failure", test_num);
            reset_dut();

            block_id = 4'd2;
            req_alloc = 1;
            @(posedge clk);
            #1;

            block_id = 4'd2;
            req_alloc = 1;
            @(posedge clk);
            #1 req_alloc = 0;

            #1;


            check_outputs(16'h0004, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Allocate then free block 10", test_num);
            reset_dut();

            block_id = 4'd10;
            req_alloc = 1;
            @(posedge clk);
            #1 req_alloc = 0;
            @(posedge clk);
            #1;

            block_id = 4'd10;
            req_free = 1;
            @(posedge clk);
            #1 req_free = 0;

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Free unallocated block failure", test_num);
            reset_dut();
            block_id = 4'd7;
            req_free = 1;
            @(posedge clk);
            #1 req_free = 0;

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Sequence of allocations (0, 1, 2)", test_num);
            reset_dut();
            block_id = 4'd0; req_alloc = 1; @(posedge clk); #1;
            block_id = 4'd1; req_alloc = 1; @(posedge clk); #1;
            block_id = 4'd2; req_alloc = 1; @(posedge clk); #1;
            req_alloc = 0;

            #1;


            check_outputs(16'h0007, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Allocate boundary block 15", test_num);
            reset_dut();
            block_id = 4'd15;
            req_alloc = 1;
            @(posedge clk);
            #1 req_alloc = 0;
            #1;

            check_outputs(16'h8000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Complex sequence", test_num);
            reset_dut();
            block_id = 4'd3; req_alloc = 1; @(posedge clk); #1;
            block_id = 4'd4; req_alloc = 1; @(posedge clk); #1;
            req_alloc = 0; req_free = 1; block_id = 4'd3; @(posedge clk); #1;
            req_free = 0; req_alloc = 1; block_id = 4'd5; @(posedge clk); #1;
            req_alloc = 0;

            #1;


            check_outputs(16'h0030, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Free wrong ID", test_num);
            reset_dut();
            block_id = 4'd12; req_alloc = 1; @(posedge clk); #1;
            req_alloc = 0; req_free = 1; block_id = 4'd11; @(posedge clk); #1;
            req_free = 0;

            #1;


            check_outputs(16'h1000, 1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_bitmap;
        input expected_success;
        begin
            if (expected_bitmap === (expected_bitmap ^ bitmap ^ expected_bitmap) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: bitmap=%h, success=%b",
                         bitmap, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bitmap=%h, success=%b",
                         expected_bitmap, expected_success);
                $display("  Got:      bitmap=%h, success=%b",
                         bitmap, success);
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
        $dumpvars(0,block_id, clk, req_alloc, req_free, rst, bitmap, success);
    end

endmodule
