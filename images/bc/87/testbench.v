`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [4:0] read_address_1;
    reg [4:0] read_address_2;
    reg write_en;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .read_address_1(read_address_1),
        .read_address_2(read_address_2),
        .write_en(write_en),
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
            @(negedge clk);
            data_in = 0;
            write_en = 0;
            read_address_1 = 0;
            read_address_2 = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Dual Read");
            reset_dut();


            @(negedge clk);
            write_en = 1;
            read_address_1 = 1;
            data_in = 32'hDEADBEEF;

            @(negedge clk);
            write_en = 0;


            read_address_1 = 5'd1;
            read_address_2 = 5'd1;

            @(negedge clk);

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple Register Write/Read");
            reset_dut();


            @(negedge clk);
            write_en = 1;
            read_address_1 = 5;
            data_in = 32'h12345678;


            @(negedge clk);
            read_address_1 = 10;
            data_in = 32'h87654321;

            @(negedge clk);
            write_en = 0;


            read_address_1 = 5'd5;
            read_address_2 = 5'd10;

            @(negedge clk);
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable Check");
            reset_dut();


            @(negedge clk);
            write_en = 1;
            read_address_1 = 15;
            data_in = 32'hAAAA_AAAA;


            @(negedge clk);
            write_en = 0;
            read_address_1 = 15;
            data_in = 32'hBBBB_BBBB;

            @(negedge clk);

            read_address_1 = 15;
            read_address_2 = 0;

            @(negedge clk);

            #1;


            check_outputs(32'hAAAA_AAAA, 32'hXXXXXXXX);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Check and Overwrite");
            reset_dut();


            @(negedge clk);
            write_en = 1;
            read_address_1 = 31;
            data_in = 32'h1111_2222;


            @(negedge clk);
            data_in = 32'hFFFF_EEEE;

            @(negedge clk);
            write_en = 0;
            read_address_1 = 31;
            read_address_2 = 31;

            @(negedge clk);
            #1;

            check_outputs(32'hFFFF_EEEE, 32'hFFFF_EEEE);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Simultaneous Read Different");
            reset_dut();


            @(negedge clk);
            write_en = 1; read_address_1 = 2; data_in = 32'h1;

            @(negedge clk);
            write_en = 1; read_address_1 = 3; data_in = 32'h2;

            @(negedge clk);
            write_en = 0;
            read_address_1 = 2;
            read_address_2 = 3;

            @(negedge clk);
            #1;

            check_outputs(32'h1, 32'h2);
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
        input [31:0] expected_read_data_1;
        input [31:0] expected_read_data_2;
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
        $dumpvars(0,clk, data_in, read_address_1, read_address_2, write_en, read_data_1, read_data_2);
    end

endmodule
