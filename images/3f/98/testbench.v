`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc_req;
    reg [2:0] alloc_size;
    reg clk;
    reg free_req;
    reg reset;
    wire alloc_success;
    wire [7:0] allocated_mem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc_req(alloc_req),
        .alloc_size(alloc_size),
        .clk(clk),
        .free_req(free_req),
        .reset(reset),
        .alloc_success(alloc_success),
        .allocated_mem(allocated_mem)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        alloc_req = 0;
        alloc_size = 0;
        free_req = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Allocation (Size 3)", test_num);
        reset_dut();
        alloc_req = 1;
        alloc_size = 3;
        @(posedge clk);
        alloc_req = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1, 8'h07);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum Allocation (Size 7)", test_num);
        reset_dut();
        alloc_req = 1;
        alloc_size = 7;
        @(posedge clk);
        alloc_req = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1, 8'h7F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Minimum Allocation (Size 1)", test_num);
        reset_dut();
        alloc_req = 1;
        alloc_size = 1;
        @(posedge clk);
        alloc_req = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1, 8'h01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Allocation followed by Free", test_num);
        reset_dut();

        alloc_req = 1;
        alloc_size = 4;
        @(posedge clk);
        alloc_req = 0;
        @(posedge clk);

        free_req = 1;
        @(posedge clk);
        free_req = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Attempt Double Allocation", test_num);
        reset_dut();

        alloc_req = 1;
        alloc_size = 2;
        @(posedge clk);
        alloc_req = 0;
        @(posedge clk);

        alloc_req = 1;
        alloc_size = 5;
        @(posedge clk);
        alloc_req = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1, 8'h03);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Sequential Alloc-Free-Alloc", test_num);
        reset_dut();

        alloc_req = 1; alloc_size = 2; @(posedge clk);
        alloc_req = 0; @(posedge clk);

        free_req = 1; @(posedge clk);
        free_req = 0; @(posedge clk);

        alloc_req = 1; alloc_size = 5; @(posedge clk);
        alloc_req = 0; @(posedge clk);

        #1;


        check_outputs(1'b1, 8'h1F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Free request on empty memory", test_num);
        reset_dut();
        free_req = 1;
        @(posedge clk);
        free_req = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset during active allocation", test_num);
        reset_dut();
        alloc_req = 1;
        alloc_size = 6;
        @(posedge clk);
        alloc_req = 0;
        @(posedge clk);

        reset = 1;
        @(posedge clk);
        reset = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0, 8'h00);
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
        input expected_alloc_success;
        input [7:0] expected_allocated_mem;
        begin
            if (expected_alloc_success === (expected_alloc_success ^ alloc_success ^ expected_alloc_success) &&
                expected_allocated_mem === (expected_allocated_mem ^ allocated_mem ^ expected_allocated_mem)) begin
                $display("PASS");
                $display("  Outputs: alloc_success=%b, allocated_mem=%h",
                         alloc_success, allocated_mem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_success=%b, allocated_mem=%h",
                         expected_alloc_success, expected_allocated_mem);
                $display("  Got:      alloc_success=%b, allocated_mem=%h",
                         alloc_success, allocated_mem);
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
        $dumpvars(0,alloc_req, alloc_size, clk, free_req, reset, alloc_success, allocated_mem);
    end

endmodule
