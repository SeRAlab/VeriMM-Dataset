`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg clk;
    reg deallocate;
    reg [4:0] request_size;
    reg reset;
    wire [4:0] allocated_size;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .clk(clk),
        .deallocate(deallocate),
        .request_size(request_size),
        .reset(reset),
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
            reset = 1;
            allocate = 0;
            deallocate = 0;
            request_size = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic successful allocation");
            reset_dut();
            @(posedge clk);
            allocate = 1;
            request_size = 5'd10;
            @(posedge clk);
            allocate = 0;
            request_size = 0;
            #5;
            #1;

            check_outputs(5'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Maximum single allocation (31 units)");
            reset_dut();
            @(posedge clk);
            allocate = 1;
            request_size = 5'd31;
            @(posedge clk);
            allocate = 0;
            request_size = 0;
            #5;
            #1;

            check_outputs(5'd31, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential allocation overflow");
            reset_dut();
            @(posedge clk);
            allocate = 1;
            request_size = 5'd20;
            @(posedge clk);
            request_size = 5'd15;
            @(posedge clk);
            allocate = 0;
            request_size = 0;
            #5;

            #1;


            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Allocate and then Free");
            reset_dut();
            @(posedge clk);
            allocate = 1;
            request_size = 5'd15;
            @(posedge clk);
            allocate = 0;
            deallocate = 1;
            request_size = 5'd15;
            @(posedge clk);
            deallocate = 0;
            request_size = 0;
            #5;

            #1;


            check_outputs(5'd15, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Deallocate more than exists");
            reset_dut();
            @(posedge clk);
            allocate = 1;
            request_size = 5'd5;
            @(posedge clk);
            allocate = 0;
            deallocate = 1;
            request_size = 5'd10;
            @(posedge clk);
            deallocate = 0;
            request_size = 0;
            #5;

            #1;


            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Fill, Free, and Re-allocate");
            reset_dut();
            @(posedge clk);
            allocate = 1;
            request_size = 5'd30;
            @(posedge clk);
            allocate = 0;
            deallocate = 1;
            request_size = 5'd30;
            @(posedge clk);
            deallocate = 0;
            allocate = 1;
            request_size = 5'd20;
            @(posedge clk);
            allocate = 0;
            request_size = 0;
            #5;

            #1;


            check_outputs(5'd20, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Multiple small valid allocations");
            reset_dut();
            @(posedge clk);
            allocate = 1;
            request_size = 5'd5;
            @(posedge clk);
            request_size = 5'd5;
            @(posedge clk);
            request_size = 5'd5;
            @(posedge clk);
            allocate = 0;
            request_size = 0;
            #5;

            #1;


            check_outputs(5'd5, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Freeing on empty memory");
            reset_dut();
            @(posedge clk);
            deallocate = 1;
            request_size = 5'd1;
            @(posedge clk);
            deallocate = 0;
            request_size = 0;
            #5;

            #1;


            check_outputs(5'd0, 1'b0);
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
        input [4:0] expected_allocated_size;
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
        $dumpvars(0,allocate, clk, deallocate, request_size, reset, allocated_size, success);
    end

endmodule
