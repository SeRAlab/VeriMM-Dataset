`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] alloc_req;
    reg clk;
    reg free_req;
    reg rst;
    wire [15:0] mem_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc_req(alloc_req),
        .clk(clk),
        .free_req(free_req),
        .rst(rst),
        .mem_status(mem_status)
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
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task do_allocate;

        input [3:0] slot_index;
        begin
            alloc_req = slot_index;
            free_req = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task do_free;

        input [3:0] slot_index;
        begin
            alloc_req = slot_index;
            free_req = 1;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocate slots 0, 1, and 2", test_num);
            reset_dut();
            do_allocate(4'd0);
            do_allocate(4'd1);
            do_allocate(4'd2);
            #1;

            check_outputs(16'h0007);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocate boundary slot 15", test_num);
            reset_dut();
            do_allocate(4'd15);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Allocate slots 0, 3, 5 then free slot 3", test_num);
            reset_dut();
            do_allocate(4'd0);
            do_allocate(4'd3);
            do_allocate(4'd5);
            do_free(4'd3);
            #1;

            check_outputs(16'h0021);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill all 16 slots", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                do_allocate(i);
            end
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill all slots then free all slots", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) do_allocate(i);
            for (i = 0; i < 16; i = i + 1) do_free(i);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Free an empty slot", test_num);
            reset_dut();
            do_allocate(4'd10);
            do_free(4'd5);
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Re-allocate an occupied slot", test_num);
            reset_dut();
            do_allocate(4'd7);
            do_allocate(4'd7);
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset after partial allocation", test_num);
            reset_dut();
            do_allocate(4'd1);
            do_allocate(4'd2);
            reset_dut();
            #1;

            check_outputs(16'h0000);
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
        testcase009();
        
        
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
        input [15:0] expected_mem_status;
        begin
            if (expected_mem_status === (expected_mem_status ^ mem_status ^ expected_mem_status)) begin
                $display("PASS");
                $display("  Outputs: mem_status=%h",
                         mem_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_status=%h",
                         expected_mem_status);
                $display("  Got:      mem_status=%h",
                         mem_status);
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
        $dumpvars(0,alloc_req, clk, free_req, rst, mem_status);
    end

endmodule
