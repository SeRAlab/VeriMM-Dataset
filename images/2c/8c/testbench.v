`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg free;
    reg request;
    reg reset;
    reg [3:0] size;
    wire allocated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .clk(clk),
        .free(free),
        .request(request),
        .reset(reset),
        .size(size),
        .allocated(allocated)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request = 0;
            size = 0;
            free = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simple Allocation", test_num);
            reset_dut();
            request = 1;
            size = 4;
            free = 0;
            @(posedge clk);
            request = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Exceed Capacity", test_num);
            reset_dut();

            request = 1; size = 10; free = 0;
            @(posedge clk);

            request = 1; size = 10; free = 0;
            @(posedge clk);
            request = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Allocate, Free, and Reallocate", test_num);
            reset_dut();
            request = 1; size = 12; free = 0;
            @(posedge clk);
            request = 1; size = 8; free = 1;
            @(posedge clk);
            request = 1; size = 10; free = 0;
            @(posedge clk);
            request = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Possible Single Allocation", test_num);
            reset_dut();
            request = 1;
            size = 15;
            free = 0;
            @(posedge clk);
            request = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence of operations", test_num);
            reset_dut();
            request = 1; size = 8; free = 0;
            @(posedge clk);
            request = 1; size = 8; free = 0;
            @(posedge clk);
            request = 1; size = 2; free = 0;
            @(posedge clk);
            request = 1; size = 4; free = 1;
            @(posedge clk);
            request = 1; size = 3; free = 0;
            @(posedge clk);
            request = 0;
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_allocated;
        begin
            if (expected_allocated === (expected_allocated ^ allocated ^ expected_allocated)) begin
                $display("PASS");
                $display("  Outputs: allocated=%b",
                         allocated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated=%b",
                         expected_allocated);
                $display("  Got:      allocated=%b",
                         allocated);
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
        $dumpvars(0,clk, free, request, reset, size, allocated);
    end

endmodule
