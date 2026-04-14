`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [39:0] add;
    reg [63:0] lo;
    reg mc_32pff;
    reg [5:0] mc_losel;
    reg slo;
    reg [1:0] state;
    wire [55:0] lo_mux;
    wire var1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add(add),
        .lo(lo),
        .mc_32pff(mc_32pff),
        .mc_losel(mc_losel),
        .slo(slo),
        .state(state),
        .lo_mux(lo_mux),
        .var1(var1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Operational Mode IDLE, mc_32pff disabled", test_num);
        state = 2'b00;
        add = 40'hA5A5A5A5A5;
        lo = 64'h0123456789ABCDEF;
        mc_32pff = 1'b0;
        mc_losel = 6'h01;
        slo = 1'b0;

        #1;


        check_outputs(56'h23456789ABCDEF, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Operational Mode CAS1, mc_32pff enabled", test_num);
        state = 2'b01;
        add = 40'hDEADBEEF69;
        lo = 64'h0123456789ABCDEF;
        mc_32pff = 1'b1;
        mc_losel = 6'h01;
        slo = 1'b0;

        #1;


        check_outputs(56'hDEADBEEF69CDEF, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Fallback logic check via slo", test_num);
        state = 2'b00;
        add = 40'hFFFFFFFFFF;
        lo = 64'hFFFFFFFFFFFFFFFF;
        mc_32pff = 1'b0;
        mc_losel = 6'h00;
        slo = 1'b1;

        #1;


        check_outputs(56'h00000000000001, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary values with mc_32pff active", test_num);
        state = 2'b01;
        add = 40'h0000000000;
        lo = 64'hFFFFFFFFFFFFFFFF;
        mc_32pff = 1'b1;
        mc_losel = 6'h01;
        slo = 1'b1;

        #1;


        check_outputs(56'h0000000000FFFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High mc_losel value, mc_32pff inactive", test_num);
        state = 2'b10;
        add = 40'h1234567890;
        lo = 64'hFEDCBA9876543210;
        mc_32pff = 1'b0;
        mc_losel = 6'h3F;
        slo = 1'b0;

        #1;


        check_outputs(56'hDCBA9876543210, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: slo fallback with zero slo input", test_num);
        state = 2'b01;
        add = 40'hAAAAAAAAAAAAAAAA;
        lo = 64'h5555555555555555;
        mc_32pff = 1'b1;
        mc_losel = 6'h00;
        slo = 1'b0;

        #1;


        check_outputs(56'h00000000000000, 1'b1);
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
        input [55:0] expected_lo_mux;
        input expected_var1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lo_mux === (expected_lo_mux ^ lo_mux ^ expected_lo_mux) &&
                expected_var1 === (expected_var1 ^ var1 ^ expected_var1)) begin
                $display("PASS");
                $display("  Outputs: lo_mux=%h, var1=%b",
                         lo_mux, var1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lo_mux=%h, var1=%b",
                         expected_lo_mux, expected_var1);
                $display("  Got:      lo_mux=%h, var1=%b",
                         lo_mux, var1);
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
