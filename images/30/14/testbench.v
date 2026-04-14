`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] block_index;
    reg clk;
    reg [1:0] request_type;
    reg reset;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .block_index(block_index),
        .clk(clk),
        .request_type(request_type),
        .reset(reset),
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
            block_index = 0;
            request_type = REQ_IDLE;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Allocation", test_num);
            reset_dut();

            block_index = 4'd5;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Allocation", test_num);
            reset_dut();


            block_index = 4'd7;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;


            block_index = 4'd7;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocate and Free", test_num);
            reset_dut();


            block_index = 4'd2;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;


            block_index = 4'd2;
            request_type = REQ_DEALLOCATE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Deallocating free block", test_num);
            reset_dut();

            block_index = 4'd10;
            request_type = REQ_DEALLOCATE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Index 0 Allocation", test_num);
            reset_dut();

            block_index = 4'd0;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Index 15 Allocation", test_num);
            reset_dut();

            block_index = 4'd15;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-allocating after Deallocation", test_num);
            reset_dut();


            block_index = 4'd3;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            block_index = 4'd3;
            request_type = REQ_DEALLOCATE;
            @(posedge clk);
            #1;

            block_index = 4'd3;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Filling multiple blocks", test_num);
            reset_dut();


            block_index = 4'd1;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            block_index = 4'd2;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            block_index = 4'd3;
            request_type = REQ_ALLOCATE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
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
        input expected_success;
        begin
            if (expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: success=%b",
                         success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: success=%b",
                         expected_success);
                $display("  Got:      success=%b",
                         success);
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
        $dumpvars(0,block_index, clk, request_type, reset, success);
    end

endmodule
