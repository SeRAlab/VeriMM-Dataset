`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_type;
    reg [7:0] request_size;
    reg rst;
    wire [7:0] allocated_memory;
    wire [7:0] free_memory;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .clk(clk),
        .req_type(req_type),
        .request_size(request_size),
        .rst(rst),
        .allocated_memory(allocated_memory),
        .free_memory(free_memory)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req_type = 0;
            request_size = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'd0, 8'd255);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Allocation", test_num);
            reset_dut();
            req_type = 1;
            request_size = 8'd100;
            @(posedge clk);
            req_type = 0;
            request_size = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd100, 8'd155);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Sequential Allocations", test_num);
            reset_dut();

            req_type = 1;
            request_size = 8'd20;
            @(posedge clk);

            req_type = 1;
            request_size = 8'd30;
            @(posedge clk);
            req_type = 0;
            request_size = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd50, 8'd205);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocate then Partial Free", test_num);
            reset_dut();

            req_type = 1;
            request_size = 8'd150;
            @(posedge clk);

            req_type = 0;
            request_size = 8'd50;
            @(posedge clk);
            req_type = 0;
            request_size = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd100, 8'd155);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Memory Allocation", test_num);
            reset_dut();
            req_type = 1;
            request_size = 8'd255;
            @(posedge clk);
            req_type = 0;
            request_size = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd255, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocate and Full Free", test_num);
            reset_dut();

            req_type = 1;
            request_size = 8'd200;
            @(posedge clk);

            req_type = 0;
            request_size = 8'd200;
            @(posedge clk);
            req_type = 0;
            request_size = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd255);
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
        input [7:0] expected_allocated_memory;
        input [7:0] expected_free_memory;
        begin
            if (expected_allocated_memory === (expected_allocated_memory ^ allocated_memory ^ expected_allocated_memory) &&
                expected_free_memory === (expected_free_memory ^ free_memory ^ expected_free_memory)) begin
                $display("PASS");
                $display("  Outputs: allocated_memory=%h, free_memory=%h",
                         allocated_memory, free_memory);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_memory=%h, free_memory=%h",
                         expected_allocated_memory, expected_free_memory);
                $display("  Got:      allocated_memory=%h, free_memory=%h",
                         allocated_memory, free_memory);
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
        $dumpvars(0,clk, req_type, request_size, rst, allocated_memory, free_memory);
    end

endmodule
