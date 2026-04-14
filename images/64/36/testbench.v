`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RST;
    reg [7:0] addr;
    reg clk_in;
    reg [3:0] ctrl_in;
    reg [15:0] data;
    wire [7:0] addr_out;
    wire [15:0] data_out;
    wire en_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RST(RST),
        .addr(addr),
        .clk_in(clk_in),
        .ctrl_in(ctrl_in),
        .data(data),
        .addr_out(addr_out),
        .data_out(data_out),
        .en_out(en_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

    begin
        RST = 1;
        addr = 0;
        data = 0;
        ctrl_in = 0;
        @(posedge clk_in);
        #1;
        RST = 0;
        @(posedge clk_in);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Load Operation (ctrl_in=1)", test_num);
        reset_dut();
        addr = 8'h10;
        data = 16'hABCD;
        ctrl_in = 4'h1;
        @(posedge clk_in);
        #1;
        #1;

        check_outputs(8'h10, 16'hABCD, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Arithmetic Operation (ctrl_in=2)", test_num);
        reset_dut();
        addr = 8'h20;
        data = 16'h1234;
        ctrl_in = 4'h2;
        @(posedge clk_in);
        #1;
        #1;

        check_outputs(8'h20, 16'h1234, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Logic Operation (ctrl_in=3)", test_num);
        reset_dut();
        addr = 8'h30;
        data = 16'hFFFF;
        ctrl_in = 4'h3;
        @(posedge clk_in);
        #1;
        #1;

        check_outputs(8'h30, 16'hFFFF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Default Behavior (ctrl_in=4)", test_num);
        reset_dut();
        addr = 8'h40;
        data = 16'h55AA;
        ctrl_in = 4'h4;
        @(posedge clk_in);
        #1;
        #1;

        check_outputs(8'h40, 16'h55AA, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Idle State (ctrl_in=0)", test_num);
        reset_dut();
        addr = 8'h50;
        data = 16'h9999;
        ctrl_in = 4'h0;
        @(posedge clk_in);
        #1;

        #1;


        check_outputs(8'h50, 16'h9999, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Boundary Values and Reset State", test_num);
        reset_dut();


        addr = 8'hFF;
        data = 16'hFFFF;
        ctrl_in = 4'hF;


        RST = 1;
        @(posedge clk_in);
        #1;

        if (en_out === 0) begin
            $display("Reset Check: en_out is 0 as expected.");
            pass_count = pass_count + 1;
        end else begin
            $display("Reset Check FAIL: en_out should be 0 during reset.");
            fail_count = fail_count + 1;
        end


        RST = 0;
        @(posedge clk_in);
        #1;
        #1;

        check_outputs(8'hFF, 16'hFFFF, 1'b1);
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
        input [7:0] expected_addr_out;
        input [15:0] expected_data_out;
        input expected_en_out;
        begin
            if (expected_addr_out === (expected_addr_out ^ addr_out ^ expected_addr_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_en_out === (expected_en_out ^ en_out ^ expected_en_out)) begin
                $display("PASS");
                $display("  Outputs: addr_out=%h, data_out=%h, en_out=%b",
                         addr_out, data_out, en_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_out=%h, data_out=%h, en_out=%b",
                         expected_addr_out, expected_data_out, expected_en_out);
                $display("  Got:      addr_out=%h, data_out=%h, en_out=%b",
                         addr_out, data_out, en_out);
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
        $dumpvars(0,RST, addr, clk_in, ctrl_in, data, addr_out, data_out, en_out);
    end

endmodule
