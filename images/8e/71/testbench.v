`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clock;
    reg [31:0] data_in;
    reg read_en;
    reg reset;
    reg write_en;
    wire [31:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .data_in(data_in),
        .read_en(read_en),
        .reset(reset),
        .write_en(write_en),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            data_in = 0;
            read_en = 0;
            write_en = 0;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clock);
            address = 32'h0000_0000;
            data_in = 32'hDEAD_BEEF;
            write_en = 1;
            @(posedge clock);
            write_en = 0;


            @(posedge clock);
            read_en = 1;
            address = 32'h0000_0000;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hDEAD_BEEF, 1'b1);

            read_en = 0;
            @(posedge clock);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clock);
            address = 32'd1023;
            data_in = 32'h1234_5678;
            write_en = 1;
            @(posedge clock);
            write_en = 0;


            @(posedge clock);
            read_en = 1;
            address = 32'd1023;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h1234_5678, 1'b1);

            read_en = 0;
            @(posedge clock);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clock);
            address = 32'h0000_0055;
            data_in = 32'hAAAA_AAAA;
            write_en = 1;
            @(posedge clock);


            data_in = 32'h5555_5555;
            write_en = 1;
            @(posedge clock);
            write_en = 0;


            @(posedge clock);
            read_en = 1;
            address = 32'h0000_0055;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h5555_5555, 1'b1);

            read_en = 0;
            @(posedge clock);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clock);
            address = 32'd10;
            data_in = 32'h0000_1111;
            write_en = 1;
            @(posedge clock);


            address = 32'd20;
            data_in = 32'hFFFF_EEEE;
            write_en = 1;
            @(posedge clock);
            write_en = 0;


            @(posedge clock);
            read_en = 1;
            address = 32'd10;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0000_1111, 1'b1);

            read_en = 0;
            @(posedge clock);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge clock);
            address = 32'h0000_000F;
            data_in = 32'hFFFF_FFFF;
            write_en = 1;
            @(posedge clock);
            write_en = 0;


            @(posedge clock);
            read_en = 1;
            address = 32'h0000_000F;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b1);

            read_en = 0;
            @(posedge clock);
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
        input [31:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,address, clock, data_in, read_en, reset, write_en, data_out, done);
    end

endmodule
