`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg clk;
    reg [2:0] request;
    reg reset;
    wire [7:0] memory_status;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .clk(clk),
        .request(request),
        .reset(reset),
        .memory_status(memory_status),
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
        request = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Allocate block 0", test_num);
        reset_dut();
        allocate = 1;
        request = 3'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h01, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Allocate block 7", test_num);
        reset_dut();
        allocate = 1;
        request = 3'd7;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h80, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Double allocation of block 2", test_num);
        reset_dut();

        allocate = 1;
        request = 3'd2;
        @(posedge clk);
        #1;

        allocate = 1;
        request = 3'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h04, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Allocate and then Free block 5", test_num);
        reset_dut();

        allocate = 1;
        request = 3'd5;
        @(posedge clk);
        #1;

        allocate = 0;
        request = 3'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Free an unallocated block 3", test_num);
        reset_dut();
        allocate = 0;
        request = 3'd3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Multiple allocations (0, 2, 4, 6)", test_num);
        reset_dut();
        allocate = 1;
        request = 3'd0; @(posedge clk); #1;
        request = 3'd2; @(posedge clk); #1;
        request = 3'd4; @(posedge clk); #1;
        request = 3'd6; @(posedge clk); #1;
        #1;

        check_outputs(8'h55, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Complex sequence of operations", test_num);
        reset_dut();

        allocate = 1; request = 3'd1; @(posedge clk); #1;
        allocate = 1; request = 3'd2; @(posedge clk); #1;

        allocate = 0; request = 3'd1; @(posedge clk); #1;

        allocate = 1; request = 3'd7; @(posedge clk); #1;
        #1;

        check_outputs(8'h84, 1'b1);
    end
        endtask

    task testcase008;

    integer i;
    begin
        test_num = 8;
        $display("Test Case %0d: Fill all memory blocks", test_num);
        reset_dut();
        allocate = 1;
        for(i=0; i<8; i=i+1) begin
            request = i;
            @(posedge clk);
            #1;
        end
        #1;

        check_outputs(8'hFF, 1'b1);
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
        input [7:0] expected_memory_status;
        input expected_success;
        begin
            if (expected_memory_status === (expected_memory_status ^ memory_status ^ expected_memory_status) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: memory_status=%h, success=%b",
                         memory_status, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_status=%h, success=%b",
                         expected_memory_status, expected_success);
                $display("  Got:      memory_status=%h, success=%b",
                         memory_status, success);
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
        $dumpvars(0,allocate, clk, request, reset, memory_status, success);
    end

endmodule
