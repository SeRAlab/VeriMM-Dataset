`timescale 1ns/1ps

module MemoryAllocator_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] addr;
    reg clk;
    reg [2:0] command;
    reg rst;
    wire [7:0] mem_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MemoryAllocator dut (
        .addr(addr),
        .clk(clk),
        .command(command),
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
            addr = 0;
            command = CMD_IDLE;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial State Check");
            reset_dut();

            #1;


            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Malloc Block 0");
            reset_dut();
            addr = 6'd0;
            command = CMD_MALLOC;
            @(posedge clk);
            #1;
            command = CMD_IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Malloc Block 4");
            reset_dut();
            addr = 6'd4;
            command = CMD_MALLOC;
            @(posedge clk);
            #1;
            command = CMD_IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0001_0000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Mallocs (0, 2, 7)");
            reset_dut();


            addr = 6'd0; command = CMD_MALLOC; @(posedge clk); #1;

            addr = 6'd2; command = CMD_MALLOC; @(posedge clk); #1;

            addr = 6'd7; command = CMD_MALLOC; @(posedge clk); #1;

            command = CMD_IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1000_0101);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Malloc and Free same block");
            reset_dut();


            addr = 6'd3; command = CMD_MALLOC; @(posedge clk); #1;

            addr = 6'd3; command = CMD_FREE;   @(posedge clk); #1;

            command = CMD_IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Malloc three, free the middle one");
            reset_dut();

            addr = 6'd0; command = CMD_MALLOC; @(posedge clk); #1;
            addr = 6'd1; command = CMD_MALLOC; @(posedge clk); #1;
            addr = 6'd2; command = CMD_MALLOC; @(posedge clk); #1;


            addr = 6'd1; command = CMD_FREE;   @(posedge clk); #1;

            command = CMD_IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0000_0101);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Malloc an already allocated block");
            reset_dut();

            addr = 6'd5; command = CMD_MALLOC; @(posedge clk); #1;

            addr = 6'd5; command = CMD_MALLOC; @(posedge clk); #1;

            command = CMD_IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0010_0000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Free a block that was never allocated");
            reset_dut();

            addr = 6'd2; command = CMD_FREE; @(posedge clk); #1;

            command = CMD_IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase009;

        integer i;
        begin
            $display("Testcase 009: Fill all 8 status bits");
            reset_dut();

            for(i = 0; i < 8; i = i + 1) begin
                addr = i;
                command = CMD_MALLOC;
                @(posedge clk);
                #1;
            end

            command = CMD_IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1111_1111);
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
        $dumpvars(0,addr, clk, command, rst, mem_status);
    end

endmodule
