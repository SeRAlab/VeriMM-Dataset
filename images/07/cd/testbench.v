`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc_req;
    reg [3:0] alloc_size;
    reg clk;
    reg free_req;
    reg rst;
    wire [3:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .alloc_req(alloc_req),
        .alloc_size(alloc_size),
        .clk(clk),
        .free_req(free_req),
        .rst(rst),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            alloc_req = 0;
            free_req = 0;
            alloc_size = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Basic single allocation", test_num);
            reset_dut();

            alloc_req = 1;
            alloc_size = 4'd4;
            @(posedge clk);
            alloc_req = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Maximum size allocation request", test_num);
            reset_dut();

            alloc_req = 1;
            alloc_size = 4'd15;
            @(posedge clk);
            alloc_req = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Allocation request with size zero", test_num);
            reset_dut();

            alloc_req = 1;
            alloc_size = 4'd0;
            @(posedge clk);
            alloc_req = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Allocation followed by immediate Free", test_num);
            reset_dut();


            alloc_req = 1;
            alloc_size = 4'd8;
            @(posedge clk);
            alloc_req = 0;
            @(posedge clk);


            free_req = 1;
            @(posedge clk);
            free_req = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Multiple allocations to fill capacity", test_num);
            reset_dut();


            alloc_req = 1;
            alloc_size = 4'd4;
            @(posedge clk);
            alloc_req = 0;
            @(posedge clk);


            alloc_req = 1;
            alloc_size = 4'd4;
            @(posedge clk);
            alloc_req = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Deallocation request on empty memory", test_num);
            reset_dut();

            free_req = 1;
            @(posedge clk);
            free_req = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Allocation after Freeing memory", test_num);
            reset_dut();


            alloc_req = 1;
            alloc_size = 4'd10;
            @(posedge clk);
            alloc_req = 0;
            @(posedge clk);


            free_req = 1;
            @(posedge clk);
            free_req = 0;
            @(posedge clk);


            alloc_req = 1;
            alloc_size = 4'd5;
            @(posedge clk);
            alloc_req = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h1);
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
        input [3:0] expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
        $dumpvars(0,alloc_req, alloc_size, clk, free_req, rst, status);
    end

endmodule
