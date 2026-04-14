`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg [31:0] data_in;
    reg mem_read;
    reg mem_write;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 32'h0;
            data_in = 32'h0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            address = 32'h00000000;
            data_in = 32'hDEADBEEF;
            mem_write = 1'b1;
            mem_read = 1'b0;
            @(posedge clk);


            #2;
            mem_write = 1'b0;
            mem_read = 1'b1;
            address = 32'h00000000;

            #5;
            $display("Testcase %0d: Write and Read at address 0x0", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            address = 32'h0000007C;
            data_in = 32'h12345678;
            mem_write = 1'b1;
            mem_read = 1'b0;
            @(posedge clk);

            #2;
            mem_write = 1'b0;
            mem_read = 1'b1;
            address = 32'h0000007C;

            #5;
            $display("Testcase %0d: Write and Read at last valid address (0x7C)", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            address = 32'h00000010;
            data_in = 32'hAAAA5555;
            mem_write = 1'b1;
            @(posedge clk);


            #2;
            address = 32'h00000020;
            data_in = 32'hBBBB6666;
            @(posedge clk);


            #2;
            mem_write = 1'b0;
            mem_read = 1'b1;
            address = 32'h00000010;

            #5;
            $display("Testcase %0d: Verify data persistence at address 0x10", test_num);
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            address = 32'h00000040;
            data_in = 32'hCAFEBABE;
            mem_write = 1'b1;
            @(posedge clk);

            #2;
            mem_write = 1'b0;
            mem_read = 1'b1;
            address = 32'h00000040;

            #5;
            $display("Testcase %0d: Middle address access (0x40)", test_num);
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,address, clk, data_in, mem_read, mem_write, data_out);
    end

endmodule
