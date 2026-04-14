`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg clk;
    reg free;
    reg [2:0] req_size;
    reg reset;
    wire [7:0] memory;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .clk(clk),
        .free(free),
        .req_size(req_size),
        .reset(reset),
        .memory(memory),
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
            free = 0;
            req_size = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            allocate = 1;
            req_size = 3;
            @(posedge clk);
            #1;
            allocate = 0;

            #1;


            check_outputs(8'b00000111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            allocate = 1; req_size = 4; @(posedge clk); #1;

            allocate = 1; req_size = 4; @(posedge clk); #1;
            allocate = 0;

            #1;


            check_outputs(8'b11111111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            allocate = 1; req_size = 5; @(posedge clk); #1;

            allocate = 1; req_size = 4; @(posedge clk); #1;
            allocate = 0;

            #1;


            check_outputs(8'b00011111, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            allocate = 1; req_size = 7; @(posedge clk); #1;

            allocate = 0; free = 1; req_size = 3; @(posedge clk); #1;
            free = 0;

            #1;


            check_outputs(8'b00001111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            allocate = 1; req_size = 6; @(posedge clk); #1;

            allocate = 0; free = 1; req_size = 2; @(posedge clk); #1;

            free = 0; allocate = 1; req_size = 3; @(posedge clk); #1;
            allocate = 0;

            #1;


            check_outputs(8'b01111111, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            allocate = 1; req_size = 0; @(posedge clk); #1;
            allocate = 0;

            #1;


            check_outputs(8'b00000000, 1'b1);
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
        input [7:0] expected_memory;
        input expected_success;
        begin
            if (expected_memory === (expected_memory ^ memory ^ expected_memory) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: memory=%h, success=%b",
                         memory, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory=%h, success=%b",
                         expected_memory, expected_success);
                $display("  Got:      memory=%h, success=%b",
                         memory, success);
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
        $dumpvars(0,allocate, clk, free, req_size, reset, memory, success);
    end

endmodule
