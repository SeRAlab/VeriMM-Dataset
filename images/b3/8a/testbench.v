`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg [63:0] d_in;
    reg load_l;
    reg ser_in;
    reg shift_l;
    wire [63:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .d_in(d_in),
        .load_l(load_l),
        .ser_in(ser_in),
        .shift_l(shift_l),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            load_l = 1;
            shift_l = 1;
            ser_in = 0;
            d_in = 64'b0;
            perform_load(64'b0);
            @(posedge ck);
            #1;
        end
        endtask
    task perform_load;

        input [63:0] value;
        begin
            d_in = value;
            load_l = 1;
            #2;
            load_l = 0;
            #2;
            load_l = 1;
            #1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Parallel Load", test_num);
            perform_load(64'hFEDCBA9876543210);
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Shift Left with ser_in=1", test_num);
            perform_load(64'h0000000000000001);
            shift_l = 0;
            ser_in = 1;
            @(posedge ck);
            #1;
            #1;

            check_outputs(64'h0000000000000003);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Multiple Shift Lefts", test_num);
            perform_load(64'hF000000000000000);
            shift_l = 0;
            ser_in = 0;
            repeat(4) @(posedge ck);
            #1;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Hold Current Value", test_num);
            perform_load(64'h5555AAAA5555AAAA);
            shift_l = 1;
            ser_in = 1;
            repeat(5) @(posedge ck);
            #1;
            #1;

            check_outputs(64'h5555AAAA5555AAAA);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Fill register via serial input", test_num);
            shift_l = 0;
            ser_in = 1;
            repeat(64) @(posedge ck);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Shift alternating bit sequence", test_num);
            shift_l = 0;
            for(i=0; i<4; i=i+1) begin
                ser_in = 1; @(posedge ck);
                ser_in = 0; @(posedge ck);
            end
            #1;
            #1;

            check_outputs(64'h00000000000000AA);
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
        input [63:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,ck, d_in, load_l, ser_in, shift_l, d_out);
    end

endmodule
