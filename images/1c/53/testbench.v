`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] request;
    reg reset;
    wire allocated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .clk(clk),
        .request(request),
        .reset(reset),
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
            request = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic allocation");
            test_num = 2;
            reset_dut();
            request = 2'b01;
            @(posedge clk);
            request = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Allocate then free");
            test_num = 3;
            reset_dut();
            request = 2'b01;
            @(posedge clk);
            request = 2'b10;
            @(posedge clk);
            request = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: State persistence after allocation");
            test_num = 4;
            reset_dut();
            request = 2'b01;
            @(posedge clk);
            request = 2'b00;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Freeing already free memory");
            test_num = 5;
            reset_dut();
            request = 2'b10;
            @(posedge clk);
            request = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Redundant allocation requests");
            test_num = 6;
            reset_dut();
            request = 2'b01; @(posedge clk);
            request = 2'b01; @(posedge clk);
            request = 2'b00; @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset while memory is allocated");
            test_num = 7;
            reset_dut();
            request = 2'b01; @(posedge clk);
            request = 2'b00; @(posedge clk);

            if (allocated !== 1'b1) $display("Warning: Setup for TC007 failed");

            reset = 1; @(posedge clk);
            reset = 0; @(posedge clk);

            #1;


            check_outputs(1'b0);
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
        $dumpvars(0,clk, request, reset, allocated);
    end

endmodule
