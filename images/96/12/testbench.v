`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg incr_cntl;
    reg [31:0] incr_val;
    reg resetn;
    reg shift;
    reg [63:0] shift_in;
    wire [31:0] data_out;
    wire [63:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .incr_cntl(incr_cntl),
        .incr_val(incr_val),
        .resetn(resetn),
        .shift(shift),
        .shift_in(shift_in),
        .data_out(data_out),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            enable = 0;
            incr_cntl = 0;
            incr_val = 0;
            shift = 0;
            shift_in = 0;
            @(posedge clock);
            #1 resetn = 1;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0000_0000, 64'h0000_0000_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Shift Operation", test_num);
            reset_dut();

            shift = 1;
            shift_in = 64'hAAAA_AAAA_BBBB_BBBB;
            @(posedge clock);
            #1;



            #1;




            check_outputs(32'hBBBB_BBBB, 64'h5555_5555_5DDD_DDDD);
            shift = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Increment Operation", test_num);
            reset_dut();


            shift = 1;
            shift_in = 64'h0000_0000_0000_0005;
            @(posedge clock);
            #1 shift = 0;


            incr_cntl = 1;
            enable = 1;
            incr_val = 32'h0000_0010;
            @(posedge clock);
            #1;




            #1;





            check_outputs(32'h0000_0005, 64'h0000_000A_8000_0002);
            incr_cntl = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable Control Check", test_num);
            reset_dut();


            shift = 1;
            shift_in = 64'h0000_0000_0000_0100;
            @(posedge clock);
            #1 shift = 0;


            incr_cntl = 1;
            enable = 0;
            incr_val = 32'hFF;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0000_0100, 64'h0000_0000_0000_0080);
            incr_cntl = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full Sequence", test_num);
            reset_dut();


            shift = 1;
            shift_in = 64'h0000_0000_0000_0123;
            @(posedge clock);


            #1 shift = 0;
            incr_cntl = 1;
            enable = 1;
            incr_val = 32'h1;
            @(posedge clock);



            #1 incr_cntl = 0;
            shift = 1;
            shift_in = 64'h0000_0000_0000_0999;
            @(posedge clock);
            #1;




            #1;





            check_outputs(32'h0000_0999, 64'h8000_0091_8000_04CC);
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
        input [63:0] expected_shift_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, shift_out=%h",
                         data_out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, shift_out=%h",
                         expected_data_out, expected_shift_out);
                $display("  Got:      data_out=%h, shift_out=%h",
                         data_out, shift_out);
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
        $dumpvars(0,clock, enable, incr_cntl, incr_val, resetn, shift, shift_in, data_out, shift_out);
    end

endmodule
