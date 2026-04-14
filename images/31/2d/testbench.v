`timescale 1ns/1ps

module MemoryManager_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] alloc_request;
    reg clk;
    reg [1:0] free_request;
    reg rst;
    wire alloc_success;
    wire free_success;
    wire [7:0] memory;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryManager dut (
        .alloc_request(alloc_request),
        .clk(clk),
        .free_request(free_request),
        .rst(rst),
        .alloc_success(alloc_success),
        .free_success(free_success),
        .memory(memory)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            alloc_request = 2'b00;
            free_request = 2'b00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Allocation (Index 1)", test_num);
            reset_dut();

            alloc_request = 2'b01;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 8'h02);
            alloc_request = 2'b00;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Allocations (Index 1 then 2)", test_num);
            reset_dut();


            alloc_request = 2'b01;
            @(posedge clk);
            #1;


            alloc_request = 2'b10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 8'h06);
            alloc_request = 2'b00;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocation then Freeing (Index 3)", test_num);
            reset_dut();


            alloc_request = 2'b11;
            @(posedge clk);
            #1;
            alloc_request = 2'b00;


            free_request = 2'b11;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 8'h00);
            free_request = 2'b00;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Failed Allocation (Block already taken)", test_num);
            reset_dut();


            alloc_request = 2'b10;
            @(posedge clk);
            #1;


            alloc_request = 2'b10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 8'h04);
            alloc_request = 2'b00;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Failed Deallocation (Block already free)", test_num);
            reset_dut();


            free_request = 2'b01;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 8'h00);
            free_request = 2'b00;
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MemoryManager Testbench");
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
        input expected_alloc_success;
        input expected_free_success;
        input [7:0] expected_memory;
        begin
            if (expected_alloc_success === (expected_alloc_success ^ alloc_success ^ expected_alloc_success) &&
                expected_free_success === (expected_free_success ^ free_success ^ expected_free_success) &&
                expected_memory === (expected_memory ^ memory ^ expected_memory)) begin
                $display("PASS");
                $display("  Outputs: alloc_success=%b, free_success=%b, memory=%h",
                         alloc_success, free_success, memory);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_success=%b, free_success=%b, memory=%h",
                         expected_alloc_success, expected_free_success, expected_memory);
                $display("  Got:      alloc_success=%b, free_success=%b, memory=%h",
                         alloc_success, free_success, memory);
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
        $dumpvars(0,alloc_request, clk, free_request, rst, alloc_success, free_success, memory);
    end

endmodule
