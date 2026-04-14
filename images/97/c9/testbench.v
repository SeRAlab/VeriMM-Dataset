`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] address;
    reg clk;
    reg read_enable;
    reg reset;
    reg [8:0] write_data;
    reg write_enable;
    wire [8:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .read_enable(read_enable),
        .reset(reset),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            address = 0;
            write_enable = 0;
            write_data = 0;
            read_enable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            address = 10'h010;
            write_data = 9'h1AA;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'h1AA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 1023", test_num);

            address = 10'h3FF;
            write_data = 9'h0FF;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;

            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'h0FF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Gating", test_num);


            address = 10'h055;
            write_data = 9'h123;
            write_enable = 0;
            @(posedge clk);


            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'h000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Overwrite", test_num);

            address = 10'h020;
            write_data = 9'h011;
            write_enable = 1;
            @(posedge clk);


            write_data = 9'h0EE;
            @(posedge clk);
            write_enable = 0;

            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'h0EE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority", test_num);


            reset = 1;
            address = 10'h005;
            write_data = 9'h1FF;
            write_enable = 1;
            @(posedge clk);

            reset = 0;
            write_enable = 0;
            read_enable = 1;
            @(posedge clk);


            #1 #1;
 check_outputs(9'h000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Reads and Writes", test_num);


            address = 10'h0A1;
            write_data = 9'h055;
            write_enable = 1;
            @(posedge clk);


            address = 10'h0B2;
            write_data = 9'h0AA;
            write_enable = 1;
            read_enable = 1;
            @(posedge clk);

            write_enable = 0;

            address = 10'h0B2;
            @(posedge clk);

            #1 #1;
 check_outputs(9'h0AA);
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
        testcase006();
        
        
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
        input [8:0] expected_read_data;
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
        $dumpvars(0,address, clk, read_enable, reset, write_data, write_enable, read_data);
    end

endmodule
