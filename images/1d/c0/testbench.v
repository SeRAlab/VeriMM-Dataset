`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg free;
    reg [3:0] request_size;
    reg reset;
    wire [4:0] allocated_address;
    wire allocation_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .clk(clk),
        .free(free),
        .request_size(request_size),
        .reset(reset),
        .allocated_address(allocated_address),
        .allocation_success(allocation_success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        free = 0;
        request_size = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Small Allocation", test_num);

        request_size = 4'd4;
        free = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(5'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Single Request Size (15 units)", test_num);

        request_size = 4'd15;
        free = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential Allocations", test_num);


        request_size = 4'd8;
        @(posedge clk);


        #1 request_size = 4'd4;
        @(posedge clk);
        #1;

        #1;


        check_outputs(5'd8, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Out of Memory Condition", test_num);


        request_size = 4'd15; @(posedge clk);
        #1 request_size = 4'd15; @(posedge clk);


        #1 request_size = 4'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(allocated_address, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Allocation after Free", test_num);


        request_size = 4'd10;
        @(posedge clk);


        #1 free = 1;
        @(posedge clk);


        #1 free = 0;
        request_size = 4'd5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(5'd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Size Request", test_num);

        request_size = 4'd0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(allocated_address, 1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Exact Capacity Allocation", test_num);

        request_size = 4'd10; @(posedge clk);
        #1 request_size = 4'd10; @(posedge clk);
        #1 request_size = 4'd10; @(posedge clk);
        #1 request_size = 4'd2;  @(posedge clk);

        #1;
        #1;

        check_outputs(5'd30, 1'b1);
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
        input [4:0] expected_allocated_address;
        input expected_allocation_success;
        begin
            if (expected_allocated_address === (expected_allocated_address ^ allocated_address ^ expected_allocated_address) &&
                expected_allocation_success === (expected_allocation_success ^ allocation_success ^ expected_allocation_success)) begin
                $display("PASS");
                $display("  Outputs: allocated_address=%h, allocation_success=%b",
                         allocated_address, allocation_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_address=%h, allocation_success=%b",
                         expected_allocated_address, expected_allocation_success);
                $display("  Got:      allocated_address=%h, allocation_success=%b",
                         allocated_address, allocation_success);
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
        $dumpvars(0,clk, free, request_size, reset, allocated_address, allocation_success);
    end

endmodule
