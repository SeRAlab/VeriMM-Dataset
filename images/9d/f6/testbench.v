`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A_i;
    reg [7:0] D_i;
    reg busclk_i;
    reg nRD_i;
    reg nWR_i;
    reg nreset_i;
    wire [7:0] D_o;
    wire [79:0] keyboard_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_i(A_i),
        .D_i(D_i),
        .busclk_i(busclk_i),
        .nRD_i(nRD_i),
        .nWR_i(nWR_i),
        .nreset_i(nreset_i),
        .D_o(D_o),
        .keyboard_o(keyboard_o)
    );

    // Clock generation (10ns period)
    initial begin
        busclk_i = 0;
        forever #5 busclk_i = ~busclk_i;
    end

        task reset_dut;

    begin
        nreset_i = 0;
        nWR_i = 1;
        nRD_i = 1;
        A_i = 0;
        D_i = 0;
        repeat(2) @(posedge busclk_i);
        #1;
        nreset_i = 1;
        @(posedge busclk_i);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Power-on Reset");
        reset_dut();
        #1;

        check_outputs(8'h00, 80'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Write to Segment 0 (keyboard_o[7:0])");
        reset_dut();
        write_bus(4'h0, 8'hA5);
        read_bus(4'h0);
        #1;

        check_outputs(8'hA5, 80'h000000000000000000A5);
        nRD_i = 1;
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Write to Segment 9 (keyboard_o[79:72])");
        reset_dut();
        write_bus(4'h9, 8'h5A);
        read_bus(4'h9);
        #1;

        check_outputs(8'h5A, 80'h5A000000000000000000);
        nRD_i = 1;
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Write/Read Segment 5");
        reset_dut();
        write_bus(4'h5, 8'hCC);
        read_bus(4'h5);
        #1;

        check_outputs(8'hCC, 80'h00000000CC0000000000);
        nRD_i = 1;
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Populate All 10 Segments");
        reset_dut();
        write_bus(4'h0, 8'h01);
        write_bus(4'h1, 8'h02);
        write_bus(4'h2, 8'h03);
        write_bus(4'h3, 8'h04);
        write_bus(4'h4, 8'h05);
        write_bus(4'h5, 8'h06);
        write_bus(4'h6, 8'h07);
        write_bus(4'h7, 8'h08);
        write_bus(4'h8, 8'h09);
        write_bus(4'h9, 8'h0A);
        read_bus(4'h9);
        #1;

        check_outputs(8'h0A, 80'h0A090807060504030201);
        nRD_i = 1;
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Global Clear Feature");
        reset_dut();
        write_bus(4'h0, 8'hFF);
        write_bus(4'hA, 8'h01);
        read_bus(4'h0);
        #1;

        check_outputs(8'h00, 80'h0);
        nRD_i = 1;
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Global Invert Feature");
        reset_dut();
        write_bus(4'hA, 8'h02);
        read_bus(4'h0);
        #1;

        check_outputs(8'hFF, 80'hFFFFFFFFFFFFFFFFFFFF);
        nRD_i = 1;
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
        input [7:0] expected_D_o;
        input [79:0] expected_keyboard_o;
        begin
            if (expected_D_o === (expected_D_o ^ D_o ^ expected_D_o) &&
                expected_keyboard_o === (expected_keyboard_o ^ keyboard_o ^ expected_keyboard_o)) begin
                $display("PASS");
                $display("  Outputs: D_o=%h, keyboard_o=%h",
                         D_o, keyboard_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_o=%h, keyboard_o=%h",
                         expected_D_o, expected_keyboard_o);
                $display("  Got:      D_o=%h, keyboard_o=%h",
                         D_o, keyboard_o);
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
        $dumpvars(0,A_i, D_i, busclk_i, nRD_i, nWR_i, nreset_i, D_o, keyboard_o);
    end

endmodule
