`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] abus;
    reg clock;
    reg [7:0] dbus_in;
    reg en;
    reg r_w;
    reg reset;
    wire [7:0] dbus_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .abus(abus),
        .clock(clock),
        .dbus_in(dbus_in),
        .en(en),
        .r_w(r_w),
        .reset(reset),
        .dbus_out(dbus_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        en = 0;
        r_w = 0;
        abus = 0;
        dbus_in = 0;
        @(posedge clock);
        #1;
        reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Basic Write and Read (Address 0x10)", test_num);
        reset_dut();

        en = 1; r_w = 0; abus = 8'h10; dbus_in = 8'hA5;
        @(posedge clock);
        #1;

        en = 1; r_w = 1; abus = 8'h10;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: High Impedance when en=0", test_num);
        reset_dut();
        en = 0; r_w = 1; abus = 8'h10;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'hZZ);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: High Impedance during Write (r_w=0)", test_num);
        reset_dut();
        en = 1; r_w = 0; abus = 8'h20; dbus_in = 8'hFF;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'hZZ);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Boundary Address 127 Write/Read", test_num);
        reset_dut();

        en = 1; r_w = 0; abus = 8'd127; dbus_in = 8'h55;
        @(posedge clock);
        #1;

        en = 1; r_w = 1; abus = 8'd127;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Overwrite location", test_num);
        reset_dut();

        en = 1; r_w = 0; abus = 8'h30; dbus_in = 8'h11;
        @(posedge clock);
        #1;

        en = 1; r_w = 0; abus = 8'h30; dbus_in = 8'h22;
        @(posedge clock);
        #1;

        en = 1; r_w = 1; abus = 8'h30;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Check initialization of Address 0 after Reset", test_num);
        reset_dut();


        en = 1; r_w = 1; abus = 8'h00;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_dbus_out;
        begin
            if (expected_dbus_out === (expected_dbus_out ^ dbus_out ^ expected_dbus_out)) begin
                $display("PASS");
                $display("  Outputs: dbus_out=%h",
                         dbus_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dbus_out=%h",
                         expected_dbus_out);
                $display("  Got:      dbus_out=%h",
                         dbus_out);
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
        $dumpvars(0,abus, clock, dbus_in, en, r_w, reset, dbus_out);
    end

endmodule
