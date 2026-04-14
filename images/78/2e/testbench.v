`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg io_pins_pwm_0_i_ival;
    reg io_pins_pwm_1_i_ival;
    reg io_pins_pwm_2_i_ival;
    reg io_pins_pwm_3_i_ival;
    reg io_pwm_port_0;
    reg io_pwm_port_1;
    reg io_pwm_port_2;
    reg io_pwm_port_3;
    reg reset;
    wire io_pins_pwm_0_o_ds;
    wire io_pins_pwm_0_o_ie;
    wire io_pins_pwm_0_o_oe;
    wire io_pins_pwm_0_o_oval;
    wire io_pins_pwm_0_o_pue;
    wire io_pins_pwm_1_o_ds;
    wire io_pins_pwm_1_o_ie;
    wire io_pins_pwm_1_o_oe;
    wire io_pins_pwm_1_o_oval;
    wire io_pins_pwm_1_o_pue;
    wire io_pins_pwm_2_o_ds;
    wire io_pins_pwm_2_o_ie;
    wire io_pins_pwm_2_o_oe;
    wire io_pins_pwm_2_o_oval;
    wire io_pins_pwm_2_o_pue;
    wire io_pins_pwm_3_o_ds;
    wire io_pins_pwm_3_o_ie;
    wire io_pins_pwm_3_o_oe;
    wire io_pins_pwm_3_o_oval;
    wire io_pins_pwm_3_o_pue;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_pins_pwm_0_i_ival(io_pins_pwm_0_i_ival),
        .io_pins_pwm_1_i_ival(io_pins_pwm_1_i_ival),
        .io_pins_pwm_2_i_ival(io_pins_pwm_2_i_ival),
        .io_pins_pwm_3_i_ival(io_pins_pwm_3_i_ival),
        .io_pwm_port_0(io_pwm_port_0),
        .io_pwm_port_1(io_pwm_port_1),
        .io_pwm_port_2(io_pwm_port_2),
        .io_pwm_port_3(io_pwm_port_3),
        .reset(reset),
        .io_pins_pwm_0_o_ds(io_pins_pwm_0_o_ds),
        .io_pins_pwm_0_o_ie(io_pins_pwm_0_o_ie),
        .io_pins_pwm_0_o_oe(io_pins_pwm_0_o_oe),
        .io_pins_pwm_0_o_oval(io_pins_pwm_0_o_oval),
        .io_pins_pwm_0_o_pue(io_pins_pwm_0_o_pue),
        .io_pins_pwm_1_o_ds(io_pins_pwm_1_o_ds),
        .io_pins_pwm_1_o_ie(io_pins_pwm_1_o_ie),
        .io_pins_pwm_1_o_oe(io_pins_pwm_1_o_oe),
        .io_pins_pwm_1_o_oval(io_pins_pwm_1_o_oval),
        .io_pins_pwm_1_o_pue(io_pins_pwm_1_o_pue),
        .io_pins_pwm_2_o_ds(io_pins_pwm_2_o_ds),
        .io_pins_pwm_2_o_ie(io_pins_pwm_2_o_ie),
        .io_pins_pwm_2_o_oe(io_pins_pwm_2_o_oe),
        .io_pins_pwm_2_o_oval(io_pins_pwm_2_o_oval),
        .io_pins_pwm_2_o_pue(io_pins_pwm_2_o_pue),
        .io_pins_pwm_3_o_ds(io_pins_pwm_3_o_ds),
        .io_pins_pwm_3_o_ie(io_pins_pwm_3_o_ie),
        .io_pins_pwm_3_o_oe(io_pins_pwm_3_o_oe),
        .io_pins_pwm_3_o_oval(io_pins_pwm_3_o_oval),
        .io_pins_pwm_3_o_pue(io_pins_pwm_3_o_pue)
    );
    task testcase001;

begin
    $display("Running testcase001: Reset state check");
    test_num = 1;
    reset = 1;
    io_pwm_port_0 = 0; io_pwm_port_1 = 0; io_pwm_port_2 = 0; io_pwm_port_3 = 0;
    io_pins_pwm_0_i_ival = 0; io_pins_pwm_1_i_ival = 0; io_pins_pwm_2_i_ival = 0; io_pins_pwm_3_i_ival = 0;
    @(posedge clock);
    #1;


    #1;



    check_outputs(0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0);
end
    endtask

    task testcase002;

begin
    $display("Running testcase002: Port 0 active");
    test_num = 2;
    reset = 1;
    @(posedge clock);
    reset = 0;
    io_pwm_port_0 = 1; io_pwm_port_1 = 0; io_pwm_port_2 = 0; io_pwm_port_3 = 0;
    @(posedge clock);
    #1;

    #1;


    check_outputs(0,0,1,1,0,  0,0,1,0,0,  0,0,1,0,0,  0,0,1,0,0);
end
    endtask

    task testcase003;

begin
    $display("Running testcase003: Port 1 active");
    test_num = 3;
    reset = 1;
    @(posedge clock);
    reset = 0;
    io_pwm_port_0 = 0; io_pwm_port_1 = 1; io_pwm_port_2 = 0; io_pwm_port_3 = 0;
    @(posedge clock);
    #1;
    #1;

    check_outputs(0,0,1,0,0,  0,0,1,1,0,  0,0,1,0,0,  0,0,1,0,0);
end
    endtask

    task testcase004;

begin
    $display("Running testcase004: Port 2 active");
    test_num = 4;
    reset = 1;
    @(posedge clock);
    reset = 0;
    io_pwm_port_0 = 0; io_pwm_port_1 = 0; io_pwm_port_2 = 1; io_pwm_port_3 = 0;
    @(posedge clock);
    #1;
    #1;

    check_outputs(0,0,1,0,0,  0,0,1,0,0,  0,0,1,1,0,  0,0,1,0,0);
end
    endtask

    task testcase005;

begin
    $display("Running testcase005: Port 3 active");
    test_num = 5;
    reset = 1;
    @(posedge clock);
    reset = 0;
    io_pwm_port_0 = 0; io_pwm_port_1 = 0; io_pwm_port_2 = 0; io_pwm_port_3 = 1;
    @(posedge clock);
    #1;
    #1;

    check_outputs(0,0,1,0,0,  0,0,1,0,0,  0,0,1,0,0,  0,0,1,1,0);
end
    endtask

    task testcase006;

begin
    $display("Running testcase006: All Ports active");
    test_num = 6;
    reset = 1;
    @(posedge clock);
    reset = 0;
    io_pwm_port_0 = 1; io_pwm_port_1 = 1; io_pwm_port_2 = 1; io_pwm_port_3 = 1;
    @(posedge clock);
    #1;
    #1;

    check_outputs(0,0,1,1,0,  0,0,1,1,0,  0,0,1,1,0,  0,0,1,1,0);
end
    endtask

    task testcase007;

begin
    $display("Running testcase007: Toggle back to zero");
    test_num = 7;
    reset = 1;
    @(posedge clock);
    reset = 0;
    io_pwm_port_0 = 0; io_pwm_port_1 = 0; io_pwm_port_2 = 0; io_pwm_port_3 = 0;
    @(posedge clock);
    #1;

    #1;


    check_outputs(0,0,1,0,0,  0,0,1,0,0,  0,0,1,0,0,  0,0,1,0,0);
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
        testcase007();
        
        
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
        input expected_io_pins_pwm_0_o_ds;
        input expected_io_pins_pwm_0_o_ie;
        input expected_io_pins_pwm_0_o_oe;
        input expected_io_pins_pwm_0_o_oval;
        input expected_io_pins_pwm_0_o_pue;
        input expected_io_pins_pwm_1_o_ds;
        input expected_io_pins_pwm_1_o_ie;
        input expected_io_pins_pwm_1_o_oe;
        input expected_io_pins_pwm_1_o_oval;
        input expected_io_pins_pwm_1_o_pue;
        input expected_io_pins_pwm_2_o_ds;
        input expected_io_pins_pwm_2_o_ie;
        input expected_io_pins_pwm_2_o_oe;
        input expected_io_pins_pwm_2_o_oval;
        input expected_io_pins_pwm_2_o_pue;
        input expected_io_pins_pwm_3_o_ds;
        input expected_io_pins_pwm_3_o_ie;
        input expected_io_pins_pwm_3_o_oe;
        input expected_io_pins_pwm_3_o_oval;
        input expected_io_pins_pwm_3_o_pue;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_pins_pwm_0_o_ds === (expected_io_pins_pwm_0_o_ds ^ io_pins_pwm_0_o_ds ^ expected_io_pins_pwm_0_o_ds) &&
                expected_io_pins_pwm_0_o_ie === (expected_io_pins_pwm_0_o_ie ^ io_pins_pwm_0_o_ie ^ expected_io_pins_pwm_0_o_ie) &&
                expected_io_pins_pwm_0_o_oe === (expected_io_pins_pwm_0_o_oe ^ io_pins_pwm_0_o_oe ^ expected_io_pins_pwm_0_o_oe) &&
                expected_io_pins_pwm_0_o_oval === (expected_io_pins_pwm_0_o_oval ^ io_pins_pwm_0_o_oval ^ expected_io_pins_pwm_0_o_oval) &&
                expected_io_pins_pwm_0_o_pue === (expected_io_pins_pwm_0_o_pue ^ io_pins_pwm_0_o_pue ^ expected_io_pins_pwm_0_o_pue) &&
                expected_io_pins_pwm_1_o_ds === (expected_io_pins_pwm_1_o_ds ^ io_pins_pwm_1_o_ds ^ expected_io_pins_pwm_1_o_ds) &&
                expected_io_pins_pwm_1_o_ie === (expected_io_pins_pwm_1_o_ie ^ io_pins_pwm_1_o_ie ^ expected_io_pins_pwm_1_o_ie) &&
                expected_io_pins_pwm_1_o_oe === (expected_io_pins_pwm_1_o_oe ^ io_pins_pwm_1_o_oe ^ expected_io_pins_pwm_1_o_oe) &&
                expected_io_pins_pwm_1_o_oval === (expected_io_pins_pwm_1_o_oval ^ io_pins_pwm_1_o_oval ^ expected_io_pins_pwm_1_o_oval) &&
                expected_io_pins_pwm_1_o_pue === (expected_io_pins_pwm_1_o_pue ^ io_pins_pwm_1_o_pue ^ expected_io_pins_pwm_1_o_pue) &&
                expected_io_pins_pwm_2_o_ds === (expected_io_pins_pwm_2_o_ds ^ io_pins_pwm_2_o_ds ^ expected_io_pins_pwm_2_o_ds) &&
                expected_io_pins_pwm_2_o_ie === (expected_io_pins_pwm_2_o_ie ^ io_pins_pwm_2_o_ie ^ expected_io_pins_pwm_2_o_ie) &&
                expected_io_pins_pwm_2_o_oe === (expected_io_pins_pwm_2_o_oe ^ io_pins_pwm_2_o_oe ^ expected_io_pins_pwm_2_o_oe) &&
                expected_io_pins_pwm_2_o_oval === (expected_io_pins_pwm_2_o_oval ^ io_pins_pwm_2_o_oval ^ expected_io_pins_pwm_2_o_oval) &&
                expected_io_pins_pwm_2_o_pue === (expected_io_pins_pwm_2_o_pue ^ io_pins_pwm_2_o_pue ^ expected_io_pins_pwm_2_o_pue) &&
                expected_io_pins_pwm_3_o_ds === (expected_io_pins_pwm_3_o_ds ^ io_pins_pwm_3_o_ds ^ expected_io_pins_pwm_3_o_ds) &&
                expected_io_pins_pwm_3_o_ie === (expected_io_pins_pwm_3_o_ie ^ io_pins_pwm_3_o_ie ^ expected_io_pins_pwm_3_o_ie) &&
                expected_io_pins_pwm_3_o_oe === (expected_io_pins_pwm_3_o_oe ^ io_pins_pwm_3_o_oe ^ expected_io_pins_pwm_3_o_oe) &&
                expected_io_pins_pwm_3_o_oval === (expected_io_pins_pwm_3_o_oval ^ io_pins_pwm_3_o_oval ^ expected_io_pins_pwm_3_o_oval) &&
                expected_io_pins_pwm_3_o_pue === (expected_io_pins_pwm_3_o_pue ^ io_pins_pwm_3_o_pue ^ expected_io_pins_pwm_3_o_pue)) begin
                $display("PASS");
                $display("  Outputs: io_pins_pwm_0_o_ds=%b, io_pins_pwm_0_o_ie=%b, io_pins_pwm_0_o_oe=%b, io_pins_pwm_0_o_oval=%b, io_pins_pwm_0_o_pue=%b, io_pins_pwm_1_o_ds=%b, io_pins_pwm_1_o_ie=%b, io_pins_pwm_1_o_oe=%b, io_pins_pwm_1_o_oval=%b, io_pins_pwm_1_o_pue=%b, io_pins_pwm_2_o_ds=%b, io_pins_pwm_2_o_ie=%b, io_pins_pwm_2_o_oe=%b, io_pins_pwm_2_o_oval=%b, io_pins_pwm_2_o_pue=%b, io_pins_pwm_3_o_ds=%b, io_pins_pwm_3_o_ie=%b, io_pins_pwm_3_o_oe=%b, io_pins_pwm_3_o_oval=%b, io_pins_pwm_3_o_pue=%b",
                         io_pins_pwm_0_o_ds, io_pins_pwm_0_o_ie, io_pins_pwm_0_o_oe, io_pins_pwm_0_o_oval, io_pins_pwm_0_o_pue, io_pins_pwm_1_o_ds, io_pins_pwm_1_o_ie, io_pins_pwm_1_o_oe, io_pins_pwm_1_o_oval, io_pins_pwm_1_o_pue, io_pins_pwm_2_o_ds, io_pins_pwm_2_o_ie, io_pins_pwm_2_o_oe, io_pins_pwm_2_o_oval, io_pins_pwm_2_o_pue, io_pins_pwm_3_o_ds, io_pins_pwm_3_o_ie, io_pins_pwm_3_o_oe, io_pins_pwm_3_o_oval, io_pins_pwm_3_o_pue);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_pins_pwm_0_o_ds=%b, io_pins_pwm_0_o_ie=%b, io_pins_pwm_0_o_oe=%b, io_pins_pwm_0_o_oval=%b, io_pins_pwm_0_o_pue=%b, io_pins_pwm_1_o_ds=%b, io_pins_pwm_1_o_ie=%b, io_pins_pwm_1_o_oe=%b, io_pins_pwm_1_o_oval=%b, io_pins_pwm_1_o_pue=%b, io_pins_pwm_2_o_ds=%b, io_pins_pwm_2_o_ie=%b, io_pins_pwm_2_o_oe=%b, io_pins_pwm_2_o_oval=%b, io_pins_pwm_2_o_pue=%b, io_pins_pwm_3_o_ds=%b, io_pins_pwm_3_o_ie=%b, io_pins_pwm_3_o_oe=%b, io_pins_pwm_3_o_oval=%b, io_pins_pwm_3_o_pue=%b",
                         expected_io_pins_pwm_0_o_ds, expected_io_pins_pwm_0_o_ie, expected_io_pins_pwm_0_o_oe, expected_io_pins_pwm_0_o_oval, expected_io_pins_pwm_0_o_pue, expected_io_pins_pwm_1_o_ds, expected_io_pins_pwm_1_o_ie, expected_io_pins_pwm_1_o_oe, expected_io_pins_pwm_1_o_oval, expected_io_pins_pwm_1_o_pue, expected_io_pins_pwm_2_o_ds, expected_io_pins_pwm_2_o_ie, expected_io_pins_pwm_2_o_oe, expected_io_pins_pwm_2_o_oval, expected_io_pins_pwm_2_o_pue, expected_io_pins_pwm_3_o_ds, expected_io_pins_pwm_3_o_ie, expected_io_pins_pwm_3_o_oe, expected_io_pins_pwm_3_o_oval, expected_io_pins_pwm_3_o_pue);
                $display("  Got:      io_pins_pwm_0_o_ds=%b, io_pins_pwm_0_o_ie=%b, io_pins_pwm_0_o_oe=%b, io_pins_pwm_0_o_oval=%b, io_pins_pwm_0_o_pue=%b, io_pins_pwm_1_o_ds=%b, io_pins_pwm_1_o_ie=%b, io_pins_pwm_1_o_oe=%b, io_pins_pwm_1_o_oval=%b, io_pins_pwm_1_o_pue=%b, io_pins_pwm_2_o_ds=%b, io_pins_pwm_2_o_ie=%b, io_pins_pwm_2_o_oe=%b, io_pins_pwm_2_o_oval=%b, io_pins_pwm_2_o_pue=%b, io_pins_pwm_3_o_ds=%b, io_pins_pwm_3_o_ie=%b, io_pins_pwm_3_o_oe=%b, io_pins_pwm_3_o_oval=%b, io_pins_pwm_3_o_pue=%b",
                         io_pins_pwm_0_o_ds, io_pins_pwm_0_o_ie, io_pins_pwm_0_o_oe, io_pins_pwm_0_o_oval, io_pins_pwm_0_o_pue, io_pins_pwm_1_o_ds, io_pins_pwm_1_o_ie, io_pins_pwm_1_o_oe, io_pins_pwm_1_o_oval, io_pins_pwm_1_o_pue, io_pins_pwm_2_o_ds, io_pins_pwm_2_o_ie, io_pins_pwm_2_o_oe, io_pins_pwm_2_o_oval, io_pins_pwm_2_o_pue, io_pins_pwm_3_o_ds, io_pins_pwm_3_o_ie, io_pins_pwm_3_o_oe, io_pins_pwm_3_o_oval, io_pins_pwm_3_o_pue);
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

endmodule
