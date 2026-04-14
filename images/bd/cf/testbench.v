`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr_in;
    reg [7:0] data_in;
    reg reset;
    reg write_en;
    wire [7:0] data_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in(addr_in),
        .data_in(data_in),
        .reset(reset),
        .write_en(write_en),
        .data_out(data_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        write_en = 0;
        forever #5 write_en = ~write_en;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            write_en = 0;
            addr_in = 0;
            data_in = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            addr_in = 4'h3;
            data_in = 8'hA5;
            write_en = 1;
            #10;
            write_en = 0;
            #10;


            #1;



            check_outputs(8'hA5, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Functionality", test_num);
            reset_dut();


            addr_in = 4'h5;
            data_in = 8'hFF;
            write_en = 1;
            #10;
            write_en = 0;


            reset_dut();


            addr_in = 4'h5;
            #10;
            #1;

            check_outputs(8'h00, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Addresses", test_num);
            reset_dut();


            addr_in = 4'hA;
            data_in = 8'h12;
            write_en = 1;
            #10;


            addr_in = 4'hB;
            data_in = 8'h34;
            write_en = 1;
            #10;
            write_en = 0;


            addr_in = 4'hA;
            #10;
            #1;

            check_outputs(8'h12, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Address Boundary Check", test_num);
            reset_dut();

            addr_in = 4'hF;
            data_in = 8'hDB;
            write_en = 1;
            #10;
            write_en = 0;
            #10;

            #1;


            check_outputs(8'hDB, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read After Write", test_num);
            reset_dut();

            addr_in = 4'h0;
            data_in = 8'h55;
            write_en = 1;
            #10;
            write_en = 0;
            #5;
            data_in = 8'h00;
            #5;

            #1;


            check_outputs(8'h55, 0);
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
        input [7:0] expected_data_out;
        input expected_error;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error=%b",
                         data_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error=%b",
                         expected_data_out, expected_error);
                $display("  Got:      data_out=%h, error=%b",
                         data_out, error);
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
        $dumpvars(0,addr_in, data_in, reset, write_en, data_out, error);
    end

endmodule
