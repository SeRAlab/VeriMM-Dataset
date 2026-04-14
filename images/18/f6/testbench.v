`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg req;
    reg reset;
    wire allocated;
    wire [15:0] mem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .addr(addr),
        .clk(clk),
        .req(req),
        .reset(reset),
        .allocated(allocated),
        .mem(mem)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 0;
            addr = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Malloc Block 0");
            reset_dut();
            req = 1;
            addr = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'h000F);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Malloc Block 2 (addr 8)");
            reset_dut();
            req = 1;
            addr = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'h0F00);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential Malloc Block 0 and 1");
            reset_dut();

            req = 1; addr = 4'd0;
            @(posedge clk);

            #1 req = 1; addr = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'h00FF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Malloc then Free Block 3 (addr 12)");
            reset_dut();

            req = 1; addr = 4'd12;
            @(posedge clk);

            #1 req = 0; addr = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Partial Free (Malloc 0 & 1, Free 0)");
            reset_dut();

            req = 1; addr = 4'd0;
            @(posedge clk);

            #1 req = 1; addr = 4'd4;
            @(posedge clk);

            #1 req = 0; addr = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'h00F0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Double Malloc on same address");
            reset_dut();

            req = 1; addr = 4'd4;
            @(posedge clk);

            #1 req = 1; addr = 4'd4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 16'h00F0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Allocate all blocks (Full Memory)");
            reset_dut();
            req = 1; addr = 4'd0; @(posedge clk);
            #1 addr = 4'd4; @(posedge clk);
            #1 addr = 4'd8; @(posedge clk);
            #1 addr = 4'd12; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Free an unallocated block");
            reset_dut();

            req = 0; addr = 4'd8;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 16'h0000);
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
        input expected_allocated;
        input [15:0] expected_mem;
        begin
            if (expected_allocated === (expected_allocated ^ allocated ^ expected_allocated) &&
                expected_mem === (expected_mem ^ mem ^ expected_mem)) begin
                $display("PASS");
                $display("  Outputs: allocated=%b, mem=%h",
                         allocated, mem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated=%b, mem=%h",
                         expected_allocated, expected_mem);
                $display("  Got:      allocated=%b, mem=%h",
                         allocated, mem);
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
        $dumpvars(0,addr, clk, req, reset, allocated, mem);
    end

endmodule
