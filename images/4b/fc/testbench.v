`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [19:0] CNTRL_bus_in;
    reg [15:0] D_bus_in;
    reg RST;
    wire [15:0] ADDR_bus_out;
    wire [15:0] B_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CNTRL_bus_in(CNTRL_bus_in),
        .D_bus_in(D_bus_in),
        .RST(RST),
        .ADDR_bus_out(ADDR_bus_out),
        .B_data_out(B_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            clear_inputs();
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task clear_inputs;

        begin
            CNTRL_bus_in = 20'h0;
            D_bus_in = 16'h0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            CNTRL_bus_in = {4'h0, 4'h0, 4'h5, 4'hA, 4'h0};
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Readback", test_num);
            reset_dut();

            CNTRL_bus_in = {4'h0, 4'h1, 4'h0, 4'h0, 3'b0, 1'b1};
            D_bus_in = 16'hABCD;
            @(posedge CLK);
            #1;

            CNTRL_bus_in = {4'h0, 4'h0, 4'h1, 4'h1, 3'b0, 1'b0};
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Dual Port Independence", test_num);
            reset_dut();

            CNTRL_bus_in = {4'h0, 4'h4, 4'h0, 4'h0, 3'b0, 1'b1};
            D_bus_in = 16'h1111;
            @(posedge CLK); #1;

            CNTRL_bus_in = {4'h0, 4'h8, 4'h0, 4'h0, 3'b0, 1'b1};
            D_bus_in = 16'h2222;
            @(posedge CLK); #1;

            CNTRL_bus_in = {4'h0, 4'h0, 4'h4, 4'h8, 3'b0, 1'b0};
            @(posedge CLK); #1;
            @(posedge CLK); #1;
            #1;

            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overwrite Data", test_num);
            reset_dut();

            CNTRL_bus_in = {4'h0, 4'h2, 4'h0, 4'h0, 3'b0, 1'b1};
            D_bus_in = 16'hAAAA;
            @(posedge CLK); #1;

            CNTRL_bus_in = {4'h0, 4'h2, 4'h0, 4'h0, 3'b0, 1'b1};
            D_bus_in = 16'h5555;
            @(posedge CLK); #1;

            CNTRL_bus_in = {4'h0, 4'h0, 4'h2, 4'h2, 3'b0, 1'b0};
            @(posedge CLK); #1;
            @(posedge CLK); #1;
            #1;

            check_outputs(16'h5555, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Simultaneous Write and Read", test_num);
            reset_dut();

            CNTRL_bus_in = {4'h0, 4'h1, 4'h0, 4'h0, 3'b0, 1'b1};
            D_bus_in = 16'h1234;
            @(posedge CLK); #1;

            CNTRL_bus_in = {4'h0, 4'h9, 4'h1, 4'h1, 3'b0, 1'b1};
            D_bus_in = 16'h9999;
            @(posedge CLK); #1;

            @(posedge CLK); #1;
            #1;

            check_outputs(16'h1234, 16'h1234);
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
        input [15:0] expected_ADDR_bus_out;
        input [15:0] expected_B_data_out;
        begin
            if (expected_ADDR_bus_out === (expected_ADDR_bus_out ^ ADDR_bus_out ^ expected_ADDR_bus_out) &&
                expected_B_data_out === (expected_B_data_out ^ B_data_out ^ expected_B_data_out)) begin
                $display("PASS");
                $display("  Outputs: ADDR_bus_out=%h, B_data_out=%h",
                         ADDR_bus_out, B_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ADDR_bus_out=%h, B_data_out=%h",
                         expected_ADDR_bus_out, expected_B_data_out);
                $display("  Got:      ADDR_bus_out=%h, B_data_out=%h",
                         ADDR_bus_out, B_data_out);
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
        $dumpvars(0,CLK, CNTRL_bus_in, D_bus_in, RST, ADDR_bus_out, B_data_out);
    end

endmodule
