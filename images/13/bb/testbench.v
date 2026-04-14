`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req;
    reg [2:0] size;
    wire allocated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .clk(clk),
        .req(req),
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
            rst = 1;
            req = 0;
            size = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple 4-byte Allocation", test_num);
            reset_dut();
            req = 1; size = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocation overflow (5 + 4 bytes)", test_num);
            reset_dut();

            req = 1; size = 3'd5;
            @(posedge clk);

            req = 1; size = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exact Full Capacity (4 + 4 bytes)", test_num);
            reset_dut();
            req = 1; size = 3'd4;
            @(posedge clk);
            req = 1; size = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocation after freeing memory", test_num);
            reset_dut();

            req = 1; size = 3'd6;
            @(posedge clk);

            req = 0; size = 3'd6;
            @(posedge clk);

            req = 1; size = 3'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Freeing unallocated memory", test_num);
            reset_dut();
            req = 0; size = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential allocations and specific free", test_num);
            reset_dut();
            req = 1; size = 3'd3; @(posedge clk);
            req = 1; size = 3'd3; @(posedge clk);
            req = 0; size = 3'd3; @(posedge clk);
            req = 1; size = 3'd5; @(posedge clk);
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
        $dumpvars(0,clk, req, size, allocated);
    end

endmodule
