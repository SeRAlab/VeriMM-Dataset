`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg read_0r;
    reg read_1r;
    reg [15:0] write_0d;
    reg write_0r;
    wire read_0a;
    wire [15:0] read_0d;
    wire read_1a;
    wire [15:0] read_1d;
    wire write_0a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .read_0r(read_0r),
        .read_1r(read_1r),
        .write_0d(write_0d),
        .write_0r(write_0r),
        .read_0a(read_0a),
        .read_0d(read_0d),
        .read_1a(read_1a),
        .read_1d(read_1d),
        .write_0a(write_0a)
    );

    // Clock generation (10ns period)
    initial begin
        read_0r = 0;
        forever #5 read_0r = ~read_0r;
    end

        task reset_dut;

        begin
            write_0r = 1'b0;
            write_0d = 16'h0;
            read_1r = 1'b0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_0d = 16'hAAAA;
            write_0r = 1'b1;



            wait(write_0a == 1'b1);
            wait(read_0a == 1'b1);
            #1;


            #1;



            check_outputs(1'b1, 16'hAAAA, 1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_0d = 16'h5555;
            write_0r = 1'b1;


            read_1r = 1'b1;


            wait(write_0a == 1'b1 && read_0a == 1'b1 && read_1a == 1'b1);
            #1;


            #1;



            check_outputs(1'b1, 16'h5555, 1'b1, 16'h5555, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_0d = 16'h1234;
            write_0r = 1'b1;
            wait(write_0a == 1'b1);
            #10;


            write_0r = 1'b0;
            read_1r = 1'b1;

            wait(read_1a == 1'b1 && read_0a == 1'b1);
            #1;

            #1;


            check_outputs(1'b1, 16'h1234, 1'b1, 16'h1234, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            write_0d = 16'hBEEF;
            write_0r = 1'b1;
            read_1r = 1'b1;
            wait(read_1a == 1'b1);


            #10;
            write_0d = 16'hC0DE;


            #20;
            wait(read_0a == 1'b1 && read_1a == 1'b1);
            #1;

            #1;


            check_outputs(1'b1, 16'hC0DE, 1'b1, 16'hC0DE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            write_0d = 16'hFFFF;
            write_0r = 1'b1;
            read_1r = 1'b1;

            wait(write_0a == 1'b1 && read_0a == 1'b1 && read_1a == 1'b1);
            #1;

            #1;


            check_outputs(1'b1, 16'hFFFF, 1'b1, 16'hFFFF, 1'b1);
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
        input expected_read_0a;
        input [15:0] expected_read_0d;
        input expected_read_1a;
        input [15:0] expected_read_1d;
        input expected_write_0a;
        begin
            if (expected_read_0a === (expected_read_0a ^ read_0a ^ expected_read_0a) &&
                expected_read_0d === (expected_read_0d ^ read_0d ^ expected_read_0d) &&
                expected_read_1a === (expected_read_1a ^ read_1a ^ expected_read_1a) &&
                expected_read_1d === (expected_read_1d ^ read_1d ^ expected_read_1d) &&
                expected_write_0a === (expected_write_0a ^ write_0a ^ expected_write_0a)) begin
                $display("PASS");
                $display("  Outputs: read_0a=%b, read_0d=%h, read_1a=%b, read_1d=%h, write_0a=%b",
                         read_0a, read_0d, read_1a, read_1d, write_0a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_0a=%b, read_0d=%h, read_1a=%b, read_1d=%h, write_0a=%b",
                         expected_read_0a, expected_read_0d, expected_read_1a, expected_read_1d, expected_write_0a);
                $display("  Got:      read_0a=%b, read_0d=%h, read_1a=%b, read_1d=%h, write_0a=%b",
                         read_0a, read_0d, read_1a, read_1d, write_0a);
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
        $dumpvars(0,read_0r, read_1r, write_0d, write_0r, read_0a, read_0d, read_1a, read_1d, write_0a);
    end

endmodule
