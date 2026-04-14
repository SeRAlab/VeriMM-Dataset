`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc_req;
    reg [2:0] block_index;
    reg clk;
    reg free_req;
    reg rst;
    wire alloc_success;
    wire free_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc_req(alloc_req),
        .block_index(block_index),
        .clk(clk),
        .free_req(free_req),
        .rst(rst),
        .alloc_success(alloc_success),
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
            alloc_req = 0;
            free_req = 0;
            block_index = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("DUT Reset performed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Checking initial state after reset", test_num);
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Allocate block 0", test_num);
            reset_dut();
            block_index = 3'd0;
            alloc_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0);
            alloc_req = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Double allocation of block 1", test_num);
            reset_dut();

            block_index = 3'd1;
            alloc_req = 1;
            @(posedge clk);
            #1;
            alloc_req = 0;
            @(posedge clk);

            block_index = 3'd1;
            alloc_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
            alloc_req = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Deallocate block 5 after allocation", test_num);
            reset_dut();

            block_index = 3'd5;
            alloc_req = 1;
            @(posedge clk);
            #1 alloc_req = 0;
            @(posedge clk);

            free_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 1);
            free_req = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Deallocate unallocated block 2", test_num);
            reset_dut();
            block_index = 3'd2;
            free_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
            free_req = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Allocate highest block index (7)", test_num);
            reset_dut();
            block_index = 3'd7;
            alloc_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0);
            alloc_req = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Allocate block 0 then 1, then free 0", test_num);
            reset_dut();

            block_index = 3'd0; alloc_req = 1; @(posedge clk); #1 alloc_req = 0; @(posedge clk);

            block_index = 3'd1; alloc_req = 1; @(posedge clk); #1 alloc_req = 0; @(posedge clk);

            block_index = 3'd0; free_req = 1; @(posedge clk);
            #1 #1;
 check_outputs(0, 1);
            free_req = 0;
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("\nTestcase %03d: Fill all 8 blocks then attempt 9th allocation", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                block_index = i;
                alloc_req = 1;
                @(posedge clk);
                #1 alloc_req = 0;
                @(posedge clk);
            end

            block_index = 3'd0;
            alloc_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
            alloc_req = 0;
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
        input expected_alloc_success;
        input expected_free_success;
        begin
            if (expected_alloc_success === (expected_alloc_success ^ alloc_success ^ expected_alloc_success) &&
                expected_free_success === (expected_free_success ^ free_success ^ expected_free_success)) begin
                $display("PASS");
                $display("  Outputs: alloc_success=%b, free_success=%b",
                         alloc_success, free_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_success=%b, free_success=%b",
                         expected_alloc_success, expected_free_success);
                $display("  Got:      alloc_success=%b, free_success=%b",
                         alloc_success, free_success);
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
        $dumpvars(0,alloc_req, block_index, clk, free_req, rst, alloc_success, free_success);
    end

endmodule
