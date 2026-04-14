`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg read_0r;
    reg read_1r;
    reg read_2r;
    reg read_3r;
    reg [7:0] write_0d;
    reg write_0r;
    wire read_0a;
    wire [7:0] read_0d;
    wire read_1a;
    wire [7:0] read_1d;
    wire read_2a;
    wire [7:0] read_2d;
    wire read_3a;
    wire [7:0] read_3d;
    wire write_0a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .read_0r(read_0r),
        .read_1r(read_1r),
        .read_2r(read_2r),
        .read_3r(read_3r),
        .write_0d(write_0d),
        .write_0r(write_0r),
        .read_0a(read_0a),
        .read_0d(read_0d),
        .read_1a(read_1a),
        .read_1d(read_1d),
        .read_2a(read_2a),
        .read_2d(read_2d),
        .read_3a(read_3a),
        .read_3d(read_3d),
        .write_0a(write_0a)
    );

        task reset_dut;

        begin
            read_0r = 0;
            read_1r = 0;
            read_2r = 0;
            read_3r = 0;
            write_0d = 8'h00;
            write_0r = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            write_0d = 8'hA5;
            write_0r = 1;
            #10;

            read_0r = 1;
            read_1r = 1;
            read_2r = 1;
            read_3r = 1;
            #10;

            #1;


            check_outputs(1'b1, 8'hA5, 1'b1, 8'hA5, 1'b1, 8'hA5, 1'b1, 8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            write_0d = 8'h5A;
            write_0r = 1;
            #10;

            read_0r = 1;
            read_1r = 0;
            read_2r = 1;
            read_3r = 0;
            #10;

            #1;


            check_outputs(1'b1, 8'h5A, 1'b0, 8'h5A, 1'b1, 8'h5A, 1'b0, 8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            write_0d = 8'hCC;
            write_0r = 1;
            #10;

            write_0r = 0;
            write_0d = 8'hEE;
            #10;

            read_0r = 1;
            read_1r = 1;
            read_2r = 1;
            read_3r = 1;
            #10;

            #1;


            check_outputs(1'b1, 8'hCC, 1'b1, 8'hCC, 1'b1, 8'hCC, 1'b1, 8'hCC, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            write_0d = 8'h12;
            write_0r = 1;
            #10;

            read_0r = 0;
            read_1r = 0;
            read_2r = 0;
            read_3r = 0;
            #10;

            #1;


            check_outputs(1'b0, 8'h12, 1'b0, 8'h12, 1'b0, 8'h12, 1'b0, 8'h12, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            write_0d = 8'hFF;
            write_0r = 1;
            #10;
            read_0r = 1;
            read_1r = 1;
            read_2r = 1;
            read_3r = 1;
            #10;
            #1;

            check_outputs(1'b1, 8'hFF, 1'b1, 8'hFF, 1'b1, 8'hFF, 1'b1, 8'hFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            write_0d = 8'h00;
            write_0r = 1;
            #10;
            read_0r = 1;
            read_1r = 1;
            read_2r = 1;
            read_3r = 1;
            #10;
            #1;

            check_outputs(1'b1, 8'h00, 1'b1, 8'h00, 1'b1, 8'h00, 1'b1, 8'h00, 1'b1);
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
        input expected_read_0a;
        input [7:0] expected_read_0d;
        input expected_read_1a;
        input [7:0] expected_read_1d;
        input expected_read_2a;
        input [7:0] expected_read_2d;
        input expected_read_3a;
        input [7:0] expected_read_3d;
        input expected_write_0a;
        begin
            if (expected_read_0a === (expected_read_0a ^ read_0a ^ expected_read_0a) &&
                expected_read_0d === (expected_read_0d ^ read_0d ^ expected_read_0d) &&
                expected_read_1a === (expected_read_1a ^ read_1a ^ expected_read_1a) &&
                expected_read_1d === (expected_read_1d ^ read_1d ^ expected_read_1d) &&
                expected_read_2a === (expected_read_2a ^ read_2a ^ expected_read_2a) &&
                expected_read_2d === (expected_read_2d ^ read_2d ^ expected_read_2d) &&
                expected_read_3a === (expected_read_3a ^ read_3a ^ expected_read_3a) &&
                expected_read_3d === (expected_read_3d ^ read_3d ^ expected_read_3d) &&
                expected_write_0a === (expected_write_0a ^ write_0a ^ expected_write_0a)) begin
                $display("PASS");
                $display("  Outputs: read_0a=%b, read_0d=%h, read_1a=%b, read_1d=%h, read_2a=%b, read_2d=%h, read_3a=%b, read_3d=%h, write_0a=%b",
                         read_0a, read_0d, read_1a, read_1d, read_2a, read_2d, read_3a, read_3d, write_0a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_0a=%b, read_0d=%h, read_1a=%b, read_1d=%h, read_2a=%b, read_2d=%h, read_3a=%b, read_3d=%h, write_0a=%b",
                         expected_read_0a, expected_read_0d, expected_read_1a, expected_read_1d, expected_read_2a, expected_read_2d, expected_read_3a, expected_read_3d, expected_write_0a);
                $display("  Got:      read_0a=%b, read_0d=%h, read_1a=%b, read_1d=%h, read_2a=%b, read_2d=%h, read_3a=%b, read_3d=%h, write_0a=%b",
                         read_0a, read_0d, read_1a, read_1d, read_2a, read_2d, read_3a, read_3d, write_0a);
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
        $dumpvars(0,read_0r, read_1r, read_2r, read_3r, write_0d, write_0r, read_0a, read_0d, read_1a, read_1d, read_2a, read_2d, read_3a, read_3d, write_0a);
    end

endmodule
