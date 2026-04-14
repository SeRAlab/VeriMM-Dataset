`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc_req;
    reg [3:0] block_id;
    reg clk;
    reg free_req;
    reg reset;
    wire alloc_granted;
    wire error;
    wire free_granted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc_req(alloc_req),
        .block_id(block_id),
        .clk(clk),
        .free_req(free_req),
        .reset(reset),
        .alloc_granted(alloc_granted),
        .error(error),
        .free_granted(free_granted)
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
            free_req = 0;
            block_id = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Simple Successful Allocation", test_num);
            reset_dut();
            block_id = 4'd5;
            alloc_req = 1;
            @(posedge clk);
            #1;
            alloc_req = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Allocate and then Free a block", test_num);
            reset_dut();

            block_id = 4'd2;
            alloc_req = 1;
            @(posedge clk);
            #1;
            alloc_req = 0;

            free_req = 1;
            @(posedge clk);
            #1;
            free_req = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Error - Double Allocation", test_num);
            reset_dut();

            block_id = 4'd7;
            alloc_req = 1;
            @(posedge clk);
            #1;
            alloc_req = 0;

            alloc_req = 1;
            @(posedge clk);
            #1;
            alloc_req = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Error - Freeing Unallocated Block", test_num);
            reset_dut();

            block_id = 4'd10;
            free_req = 1;
            @(posedge clk);
            #1;
            free_req = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Allocate Multiple Blocks then Free one", test_num);
            reset_dut();

            block_id = 4'd1;
            alloc_req = 1; @(posedge clk); #1; alloc_req = 0;

            block_id = 4'd15;
            alloc_req = 1; @(posedge clk); #1; alloc_req = 0;

            block_id = 4'd1;
            free_req = 1; @(posedge clk); #1; free_req = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Check Reset clears allocations", test_num);
            reset_dut();

            block_id = 4'd3;
            alloc_req = 1; @(posedge clk); #1; alloc_req = 0;

            reset_dut();

            block_id = 4'd3;
            alloc_req = 1; @(posedge clk); #1; alloc_req = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Error - Double Freeing", test_num);
            reset_dut();

            block_id = 4'd8;
            alloc_req = 1; @(posedge clk); #1; alloc_req = 0;

            free_req = 1; @(posedge clk); #1; free_req = 0;

            free_req = 1; @(posedge clk); #1; free_req = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_alloc_granted;
        input expected_error;
        input expected_free_granted;
        begin
            if (expected_alloc_granted === (expected_alloc_granted ^ alloc_granted ^ expected_alloc_granted) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_free_granted === (expected_free_granted ^ free_granted ^ expected_free_granted)) begin
                $display("PASS");
                $display("  Outputs: alloc_granted=%b, error=%b, free_granted=%b",
                         alloc_granted, error, free_granted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_granted=%b, error=%b, free_granted=%b",
                         expected_alloc_granted, expected_error, expected_free_granted);
                $display("  Got:      alloc_granted=%b, error=%b, free_granted=%b",
                         alloc_granted, error, free_granted);
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
        $dumpvars(0,alloc_req, block_id, clk, free_req, reset, alloc_granted, error, free_granted);
    end

endmodule
