`timescale 1ns/1ps

module memory_management_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg free_req;
    reg malloc_req;
    reg [3:0] mem_id;
    reg rst;
    wire alloc_success;
    wire [3:0] allocated_id;
    wire free_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_management dut (
        .clk(clk),
        .free_req(free_req),
        .malloc_req(malloc_req),
        .mem_id(mem_id),
        .rst(rst),
        .alloc_success(alloc_success),
        .allocated_id(allocated_id),
        .free_success(free_success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            malloc_req = 0;
            free_req = 0;
            mem_id = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single malloc request", test_num);
            reset_dut();

            malloc_req = 1;
            @(posedge clk);
            #1 malloc_req = 0;


            #1;



            check_outputs(1, 4'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Malloc then Free", test_num);
            reset_dut();


            malloc_req = 1;
            @(posedge clk);
            #1 malloc_req = 0;
            @(posedge clk);


            free_req = 1;
            mem_id = 4'h0;
            @(posedge clk);
            #1 free_req = 0;

            #1;


            check_outputs(0, 4'h0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential allocations", test_num);
            reset_dut();


            malloc_req = 1;
            @(posedge clk);
            #1;

            malloc_req = 1;
            @(posedge clk);
            #1;

            malloc_req = 1;
            @(posedge clk);
            #1 malloc_req = 0;


            #1;



            check_outputs(1, 4'h2, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Allocation failure when pool full", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                malloc_req = 1;
                @(posedge clk);
                #1;
            end


            malloc_req = 1;
            @(posedge clk);
            #1 malloc_req = 0;

            #1;


            check_outputs(0, 4'h0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Freeing an unallocated ID", test_num);
            reset_dut();


            free_req = 1;
            mem_id = 4'h5;
            @(posedge clk);
            #1 free_req = 0;

            #1;


            check_outputs(0, 4'h0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Re-allocating a freed ID", test_num);
            reset_dut();


            malloc_req = 1;
            @(posedge clk);
            #1 malloc_req = 0;
            @(posedge clk);


            free_req = 1;
            mem_id = 4'h0;
            @(posedge clk);
            #1 free_req = 0;
            @(posedge clk);


            malloc_req = 1;
            repeat(15) @(posedge clk);
            #1;


            malloc_req = 1;
            @(posedge clk);
            #1 malloc_req = 0;

            #1;


            check_outputs(1, 4'h0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Malloc and Free", test_num);
            reset_dut();


            malloc_req = 1;
            @(posedge clk);
            #1 malloc_req = 0;
            @(posedge clk);


            malloc_req = 1;
            free_req = 1;
            mem_id = 4'h0;
            @(posedge clk);
            #1;
            malloc_req = 0;
            free_req = 0;

            #1;


            check_outputs(1, 4'h1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_management Testbench");
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
        input expected_alloc_success;
        input [3:0] expected_allocated_id;
        input expected_free_success;
        begin
            if (expected_alloc_success === (expected_alloc_success ^ alloc_success ^ expected_alloc_success) &&
                expected_allocated_id === (expected_allocated_id ^ allocated_id ^ expected_allocated_id) &&
                expected_free_success === (expected_free_success ^ free_success ^ expected_free_success)) begin
                $display("PASS");
                $display("  Outputs: alloc_success=%b, allocated_id=%h, free_success=%b",
                         alloc_success, allocated_id, free_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_success=%b, allocated_id=%h, free_success=%b",
                         expected_alloc_success, expected_allocated_id, expected_free_success);
                $display("  Got:      alloc_success=%b, allocated_id=%h, free_success=%b",
                         alloc_success, allocated_id, free_success);
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
        $dumpvars(0,clk, free_req, malloc_req, mem_id, rst, alloc_success, allocated_id, free_success);
    end

endmodule
