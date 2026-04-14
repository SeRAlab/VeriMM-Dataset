`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg clk;
    reg free;
    wire [3:0] memory_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .clk(clk),
        .free(free),
        .memory_status(memory_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            allocate = 0;
            free = 1;
            repeat(5) @(posedge clk);
            free = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Initial state", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Allocate 1 slot", test_num);
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Allocate all 4 slots", test_num);
            allocate = 1;
            repeat(4) @(posedge clk);
            allocate = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Allocation overflow test", test_num);
            allocate = 1;
            repeat(5) @(posedge clk);
            allocate = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Allocate 2 then Free 1", test_num);
            allocate = 1;
            repeat(2) @(posedge clk);
            allocate = 0;
            free = 1;
            @(posedge clk);
            free = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Free on empty memory", test_num);
            free = 1;
            @(posedge clk);
            free = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Complex Alloc/Free sequence", test_num);
            allocate = 1;
            repeat(2) @(posedge clk);
            allocate = 0;
            free = 1;
            @(posedge clk);
            free = 0;
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0011);
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
        input [3:0] expected_memory_status;
        begin
            if (expected_memory_status === (expected_memory_status ^ memory_status ^ expected_memory_status)) begin
                $display("PASS");
                $display("  Outputs: memory_status=%h",
                         memory_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_status=%h",
                         expected_memory_status);
                $display("  Got:      memory_status=%h",
                         memory_status);
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
        $dumpvars(0,allocate, clk, free, memory_status);
    end

endmodule
