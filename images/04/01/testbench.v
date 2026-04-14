`timescale 1ns/1ps

module memory_manager_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] alloc_size;
    reg clk;
    reg request_alloc;
    reg request_free;
    reg rst;
    wire [3:0] allocated_size;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_manager dut (
        .alloc_size(alloc_size),
        .clk(clk),
        .request_alloc(request_alloc),
        .request_free(request_free),
        .rst(rst),
        .allocated_size(allocated_size),
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
            alloc_size = 4'd0;
            request_alloc = 1'b0;
            request_free = 1'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Allocation", test_num);
            reset_dut();
            @(negedge clk);
            alloc_size = 4'd5;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Accumulative Allocation", test_num);
            reset_dut();
            @(negedge clk);
            alloc_size = 4'd4;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            @(negedge clk);
            alloc_size = 4'd3;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            #1;

            check_outputs(4'd7, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocation Failure (Exceed Capacity)", test_num);
            reset_dut();
            @(negedge clk);
            alloc_size = 4'd10;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            @(negedge clk);
            alloc_size = 4'd7;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;

            #1;


            check_outputs(4'd10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Deallocation", test_num);
            reset_dut();
            @(negedge clk);
            alloc_size = 4'd10;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            @(negedge clk);
            alloc_size = 4'd4;
            request_free = 1'b1;
            @(negedge clk);
            request_free = 1'b0;
            #1;

            check_outputs(4'd6, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Deallocation Failure (Underflow)", test_num);
            reset_dut();
            @(negedge clk);
            alloc_size = 4'd3;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            @(negedge clk);
            alloc_size = 4'd5;
            request_free = 1'b1;
            @(negedge clk);
            request_free = 1'b0;

            #1;


            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exact Max Capacity Allocation", test_num);
            reset_dut();
            @(negedge clk);
            alloc_size = 4'd15;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocation after Deallocation", test_num);
            reset_dut();
            @(negedge clk);
            alloc_size = 4'd12;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            @(negedge clk);
            alloc_size = 4'd8;
            request_free = 1'b1;
            @(negedge clk);
            request_free = 1'b0;
            @(negedge clk);
            alloc_size = 4'd5;
            request_alloc = 1'b1;
            @(negedge clk);
            request_alloc = 1'b0;
            #1;

            check_outputs(4'd9, 1'b1);
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
        input [3:0] expected_allocated_size;
        input expected_success;
        begin
            if (expected_allocated_size === (expected_allocated_size ^ allocated_size ^ expected_allocated_size) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: allocated_size=%h, success=%b",
                         allocated_size, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_size=%h, success=%b",
                         expected_allocated_size, expected_success);
                $display("  Got:      allocated_size=%h, success=%b",
                         allocated_size, success);
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
        $dumpvars(0,alloc_size, clk, request_alloc, request_free, rst, allocated_size, success);
    end

endmodule
