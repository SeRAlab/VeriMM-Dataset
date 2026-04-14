`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_reg_addr;
    reg reg_write;
    reg [31:0] write_data;
    reg [3:0] write_reg_addr;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_reg_addr(read_reg_addr),
        .reg_write(reg_write),
        .write_data(write_data),
        .write_reg_addr(write_reg_addr),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reg_write = 0;
            write_reg_addr = 0;
            write_data = 0;
            read_reg_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write to Reg 5 and Read back", test_num);


            reg_write = 1;
            write_reg_addr = 4'h5;
            write_data = 32'hA5A5_5A5A;
            @(posedge clk);
            #1;


            reg_write = 0;
            read_reg_addr = 4'h5;
            #2;

            #1;


            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write to Reg 15 (Max Addr)", test_num);


            reg_write = 1;
            write_reg_addr = 4'hF;
            write_data = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;


            reg_write = 0;
            read_reg_addr = 4'hF;
            #2;

            #1;


            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Attempt write with reg_write=0", test_num);


            reg_write = 1;
            write_reg_addr = 4'h2;
            write_data = 32'h1111_2222;
            @(posedge clk);
            #1;


            reg_write = 0;
            write_reg_addr = 4'h2;
            write_data = 32'hEEEE_EEEE;
            @(posedge clk);
            #1;


            read_reg_addr = 4'h2;
            #2;

            #1;


            check_outputs(32'h1111_2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Read addr A while writing to addr B", test_num);


            reg_write = 1;
            write_reg_addr = 4'h1;
            write_data = 32'hBEEF_CAFE;
            @(posedge clk);
            #1;


            read_reg_addr = 4'h1;
            reg_write = 1;
            write_reg_addr = 4'h2;
            write_data = 32'h0000_1234;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hBEEF_CAFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Multiple writes followed by reading first written", test_num);


            reg_write = 1;
            write_reg_addr = 4'h8;
            write_data = 32'h1234_5678;
            @(posedge clk);
            #1;


            write_reg_addr = 4'h9;
            write_data = 32'h8765_4321;
            @(posedge clk);
            #1;


            reg_write = 0;
            read_reg_addr = 4'h8;
            #2;

            #1;


            check_outputs(32'h1234_5678);
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
        input [31:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_reg_addr, reg_write, write_data, write_reg_addr, read_data);
    end

endmodule
