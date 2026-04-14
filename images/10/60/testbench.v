`timescale 1ns/1ps

module memory_controller_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg [3:0] block_size;
    reg clk;
    reg request;
    reg reset;
    wire [7:0] allocated_memory;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_controller dut (
        .allocate(allocate),
        .block_size(block_size),
        .clk(clk),
        .request(request),
        .reset(reset),
        .allocated_memory(allocated_memory),
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
        block_size = 0;
        request = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(8'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Allocation (Size 10)", test_num);
        reset_dut();
        allocate = 1;
        block_size = 4'd10;
        request = 1;
        @(posedge clk);
        #1 request = 0;
        #1;

        check_outputs(8'd10, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Allocate and then Deallocate", test_num);
        reset_dut();

        allocate = 1; block_size = 4'd15; request = 1;
        @(posedge clk);
        #1;

        allocate = 0; block_size = 4'd5; request = 1;
        @(posedge clk);
        #1 request = 0;
        #1;

        check_outputs(8'd10, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Sequential Allocations", test_num);
        reset_dut();
        allocate = 1; request = 1;
        block_size = 4'd10; @(posedge clk); #1;
        block_size = 4'd15; @(posedge clk); #1;
        block_size = 4'd5;  @(posedge clk); #1;
        request = 0;
        #1;

        check_outputs(8'd30, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Deallocation Underflow", test_num);
        reset_dut();

        allocate = 1; block_size = 4'd5; request = 1;
        @(posedge clk); #1;

        allocate = 0; block_size = 4'd10; request = 1;
        @(posedge clk);
        #1 request = 0;

        #1;


        check_outputs(8'd5, 1'b0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Fill Memory to Max Capacity (255)", test_num);
        reset_dut();
        allocate = 1; request = 1;
        block_size = 4'd15;

        repeat(17) begin
            @(posedge clk);
            #1;
        end
        request = 0;
        #1;

        check_outputs(8'd255, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Allocation Overflow", test_num);
        reset_dut();

        allocate = 1; request = 1;
        block_size = 4'd10;
        repeat(25) begin
            @(posedge clk);
            #1;
        end

        block_size = 4'd10;
        @(posedge clk);
        #1 request = 0;

        #1;


        check_outputs(8'd250, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_controller Testbench");
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
        input [7:0] expected_allocated_memory;
        input expected_success;
        begin
            if (expected_allocated_memory === (expected_allocated_memory ^ allocated_memory ^ expected_allocated_memory) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: allocated_memory=%h, success=%b",
                         allocated_memory, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_memory=%h, success=%b",
                         expected_allocated_memory, expected_success);
                $display("  Got:      allocated_memory=%h, success=%b",
                         allocated_memory, success);
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
        $dumpvars(0,allocate, block_size, clk, request, reset, allocated_memory, success);
    end

endmodule
