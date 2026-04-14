`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] read_address_1;
    reg [1:0] read_address_2;
    reg [1:0] write_address;
    reg [15:0] write_data;
    reg write_enable;
    wire [15:0] read_data_1;
    wire [15:0] read_data_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_address_1(read_address_1),
        .read_address_2(read_address_2),
        .write_address(write_address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            write_enable = 0;
            write_address = 0;
            write_data = 0;
            read_address_1 = 0;
            read_address_2 = 0;



            @(negedge clk);
            write_enable = 1;
            write_address = 2'd0; write_data = 16'h0000; @(negedge clk);
            write_address = 2'd1; write_data = 16'h0000; @(negedge clk);
            write_address = 2'd2; write_data = 16'h0000; @(negedge clk);
            write_address = 2'd3; write_data = 16'h0000; @(negedge clk);
            write_enable = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 0xAAAA to Reg 0 and read back", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            write_address = 2'd0;
            write_data = 16'hAAAA;

            @(negedge clk);
            write_enable = 0;
            read_address_1 = 2'd0;
            read_address_2 = 2'd1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify write_enable=0 prevents data updates", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 0;
            write_address = 2'd1;
            write_data = 16'h5555;

            @(negedge clk);
            read_address_1 = 2'd1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous read from Reg 2 and Reg 3", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            write_address = 2'd2;
            write_data = 16'h1234;
            @(negedge clk);
            write_address = 2'd3;
            write_data = 16'hABCD;

            @(negedge clk);
            write_enable = 0;
            read_address_1 = 2'd2;
            read_address_2 = 2'd3;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234, 16'hABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Reg 1 and check Reg 0 is unchanged", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            write_address = 2'd0; write_data = 16'hF0F0;
            @(negedge clk);
            write_address = 2'd1; write_data = 16'h0F0F;


            @(negedge clk);
            write_address = 2'd1; write_data = 16'hFFFF;

            @(negedge clk);
            write_enable = 0;
            read_address_1 = 2'd1;
            read_address_2 = 2'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'hF0F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify boundary values 0xFFFF", test_num);
            reset_dut();

            @(negedge clk);
            write_enable = 1;
            write_address = 2'd3;
            write_data = 16'hFFFF;

            @(negedge clk);
            write_enable = 0;
            read_address_1 = 2'd3;
            read_address_2 = 2'd3;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
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
        input [15:0] expected_read_data_1;
        input [15:0] expected_read_data_2;
        begin
            if (expected_read_data_1 === (expected_read_data_1 ^ read_data_1 ^ expected_read_data_1) &&
                expected_read_data_2 === (expected_read_data_2 ^ read_data_2 ^ expected_read_data_2)) begin
                $display("PASS");
                $display("  Outputs: read_data_1=%h, read_data_2=%h",
                         read_data_1, read_data_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data_1=%h, read_data_2=%h",
                         expected_read_data_1, expected_read_data_2);
                $display("  Got:      read_data_1=%h, read_data_2=%h",
                         read_data_1, read_data_2);
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
        $dumpvars(0,clk, read_address_1, read_address_2, write_address, write_data, write_enable, read_data_1, read_data_2);
    end

endmodule
