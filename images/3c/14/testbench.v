`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] cmd;
    reg [2:0] index;
    reg rst;
    wire [7:0] mem_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .clk(clk),
        .cmd(cmd),
        .index(index),
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
        cmd = 0;
        index = 0;
        @(posedge clk);
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task send_command;

        input [2:0] c;
        input [2:0] i;
        begin
            cmd = c;
            index = i;
            @(posedge clk);
            #1;
            cmd = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset State Verification", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Allocation (Index 0)", test_num);
        reset_dut();
        send_command(3'd1, 3'd0);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Allocation (Index 7)", test_num);
        reset_dut();
        send_command(3'd1, 3'd7);
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Allocations (0, 2, 5)", test_num);
        reset_dut();
        send_command(3'd1, 3'd0);
        send_command(3'd1, 3'd2);
        send_command(3'd1, 3'd5);
        #1;

        check_outputs(8'b00100101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Malloc and Free Sequence", test_num);
        reset_dut();
        send_command(3'd1, 3'd1);
        send_command(3'd1, 3'd3);
        send_command(3'd2, 3'd1);
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Fill All Blocks", test_num);
        reset_dut();
        for(i=0; i<8; i=i+1) begin
            send_command(3'd1, i[2:0]);
        end
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Free Unallocated Block", test_num);
        reset_dut();
        send_command(3'd1, 3'd4);
        send_command(3'd2, 3'd2);
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Re-allocation after Free", test_num);
        reset_dut();
        send_command(3'd1, 3'd6);
        send_command(3'd2, 3'd6);
        send_command(3'd1, 3'd6);
        #1;

        check_outputs(8'h40);
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
        input [7:0] expected_mem_status;
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
        $dumpvars(0,clk, cmd, index, rst, mem_status);
    end

endmodule
