`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg clk;
    reg free;
    reg rst;
    wire [4:0] memory_blocks;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .clk(clk),
        .free(free),
        .rst(rst),
        .memory_blocks(memory_blocks)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            allocate = 0;
            free = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            allocate = 1;
            repeat (3) @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(5'b00111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            allocate = 1;
            repeat (5) @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            allocate = 1;
            repeat (6) @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            allocate = 1;
            repeat (3) @(posedge clk);
            #1 allocate = 0;
            free = 1;
            @(posedge clk);
            #1 free = 0;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;
            free = 1;
            repeat (3) @(posedge clk);
            #1 free = 0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            allocate = 1;
            repeat (5) @(posedge clk);
            #1 allocate = 0;
            free = 1;
            repeat (5) @(posedge clk);
            #1 free = 0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            allocate = 1;
            repeat (2) @(posedge clk);
            #1 allocate = 0;
            free = 1;
            @(posedge clk);
            #1 free = 0;
            allocate = 1;
            repeat (3) @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(5'b01111);
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
        input [4:0] expected_memory_blocks;
        begin
            if (expected_memory_blocks === (expected_memory_blocks ^ memory_blocks ^ expected_memory_blocks)) begin
                $display("PASS");
                $display("  Outputs: memory_blocks=%h",
                         memory_blocks);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_blocks=%h",
                         expected_memory_blocks);
                $display("  Got:      memory_blocks=%h",
                         memory_blocks);
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
        $dumpvars(0,allocate, clk, free, rst, memory_blocks);
    end

endmodule
