`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] read_address_a;
    reg [4:0] read_address_b;
    reg reset;
    reg write;
    reg [4:0] write_address;
    reg [31:0] write_data;
    wire [31:0] read_out_a;
    wire [31:0] read_out_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_address_a(read_address_a),
        .read_address_b(read_address_b),
        .reset(reset),
        .write(write),
        .write_address(write_address),
        .write_data(write_data),
        .read_out_a(read_out_a),
        .read_out_b(read_out_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write = 0;
            write_address = 0;
            write_data = 0;
            read_address_a = 0;
            read_address_b = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset Check", test_num);
            reset_dut();


            read_address_a = 5'd10;
            read_address_b = 5'd31;

            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Register Zero Constant Check", test_num);
            reset_dut();


            @(posedge clk);
            write = 1;
            write_address = 5'd0;
            write_data = 32'hFFFF_FFFF;


            @(posedge clk);
            write = 0;

            read_address_a = 5'd0;
            read_address_b = 5'd0;

            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Write/Read Check", test_num);
            reset_dut();


            @(posedge clk);
            write = 1;
            write_address = 5'd1;
            write_data = 32'h1234_5678;
            @(posedge clk);
            write = 0;


            read_address_a = 5'd1;
            read_address_b = 5'd0;

            #1;
            #1;

            check_outputs(32'h1234_5678, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple Register Read Check", test_num);
            reset_dut();


            @(posedge clk);
            write = 1;
            write_address = 5'd15;
            write_data = 32'hAAAA_BBBB;
            @(posedge clk);


            write_address = 5'd25;
            write_data = 32'hCCCC_DDDD;
            @(posedge clk);
            write = 0;


            read_address_a = 5'd15;
            read_address_b = 5'd25;

            #1;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Negative Edge Write Timing Check", test_num);
            reset_dut();


            @(posedge clk);
            write = 1;
            write_address = 5'd7;
            write_data = 32'h5555_AAAA;


            read_address_a = 5'd7;
            #1;
            if (read_out_a == 32'h0)
                $display("  Info: Data not yet written at PosEdge (Correct)");


            @(negedge clk);
            #1;


            read_address_a = 5'd7;
            read_address_b = 5'd0;

            #1;


            check_outputs(32'h5555_AAAA, 32'h0);

            @(posedge clk);
            write = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Write Enable Check", test_num);
            reset_dut();

            @(posedge clk);
            write = 0;
            write_address = 5'd5;
            write_data = 32'hDEAD_BEEF;
            @(posedge clk);

            read_address_a = 5'd5;
            read_address_b = 5'd0;

            #1;
            #1;

            check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_read_out_a;
        input [31:0] expected_read_out_b;
        begin
            if (expected_read_out_a === (expected_read_out_a ^ read_out_a ^ expected_read_out_a) &&
                expected_read_out_b === (expected_read_out_b ^ read_out_b ^ expected_read_out_b)) begin
                $display("PASS");
                $display("  Outputs: read_out_a=%h, read_out_b=%h",
                         read_out_a, read_out_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_out_a=%h, read_out_b=%h",
                         expected_read_out_a, expected_read_out_b);
                $display("  Got:      read_out_a=%h, read_out_b=%h",
                         read_out_a, read_out_b);
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
        $dumpvars(0,clk, read_address_a, read_address_b, reset, write, write_address, write_data, read_out_a, read_out_b);
    end

endmodule
