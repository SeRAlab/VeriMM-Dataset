`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req_type;
    reg reset;
    reg [7:0] size;
    wire [7:0] alloc_address;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .clk(clk),
        .req_type(req_type),
        .reset(reset),
        .size(size),
        .alloc_address(alloc_address),
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
            req_type = 0;
            size = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Allocation (Malloc 16 bytes)", test_num);
            reset_dut();

            req_type = 4'd1;
            size = 8'd16;
            @(posedge clk);
            #1;
            req_type = 4'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Memory Exhaustion", test_num);
            reset_dut();


            req_type = 4'd1;
            size = 8'd200;
            @(posedge clk);
            #1;


            req_type = 4'd1;
            size = 8'd100;
            @(posedge clk);
            #1;
            req_type = 4'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(alloc_address, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Allocate and Free", test_num);
            reset_dut();


            req_type = 4'd1;
            size = 8'd64;
            @(posedge clk);
            #1;


            req_type = 4'd2;
            size = 8'h00;
            @(posedge clk);
            #1;


            req_type = 4'd1;
            size = 8'd64;
            @(posedge clk);
            #1;
            req_type = 4'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive Allocations", test_num);
            reset_dut();


            req_type = 4'd1;
            size = 8'd32;
            @(posedge clk);
            #1;


            req_type = 4'd1;
            size = 8'd32;
            @(posedge clk);
            #1;
            req_type = 4'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h20, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fragmented Re-allocation", test_num);
            reset_dut();


            req_type = 4'd1; size = 8'd32; @(posedge clk); #1;

            req_type = 4'd1; size = 8'd32; @(posedge clk); #1;

            req_type = 4'd2; size = 8'h00; @(posedge clk); #1;


            req_type = 4'd1;
            size = 8'd16;
            @(posedge clk);
            #1;
            req_type = 4'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_alloc_address;
        input expected_success;
        begin
            if (expected_alloc_address === (expected_alloc_address ^ alloc_address ^ expected_alloc_address) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: alloc_address=%h, success=%b",
                         alloc_address, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_address=%h, success=%b",
                         expected_alloc_address, expected_success);
                $display("  Got:      alloc_address=%h, success=%b",
                         alloc_address, success);
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
        $dumpvars(0,clk, req_type, reset, size, alloc_address, success);
    end

endmodule
