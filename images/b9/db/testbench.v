`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] address_i;
    reg [1:0] be_i;
    reg clk_i;
    reg [15:0] data_i;
    reg wren_i;
    wire [15:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_i(address_i),
        .be_i(be_i),
        .clk_i(clk_i),
        .data_i(data_i),
        .wren_i(wren_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        address_i = 0;
        be_i = 2'b11;
        data_i = 0;
        wren_i = 1;
        @(posedge clk_i);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        address_i = 18'h0000A;
        data_i = 16'hABCD;
        wren_i = 0;
        be_i = 2'b00;
        @(posedge clk_i);
        #2;
        wren_i = 1;
        be_i = 2'b11;
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        address_i = 18'h0000B;
        data_i = 16'h0000;
        wren_i = 0;
        be_i = 2'b00;
        @(posedge clk_i);
        #2;

        data_i = 16'hFF55;
        be_i = 2'b10;
        @(posedge clk_i);
        #2;
        wren_i = 1;
        be_i = 2'b11;
        #1;
        #1;

        check_outputs(16'h0055);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        address_i = 18'h0000C;
        data_i = 16'h0000;
        wren_i = 0;
        be_i = 2'b00;
        @(posedge clk_i);
        #2;

        data_i = 16'hAAFF;
        be_i = 2'b01;
        @(posedge clk_i);
        #2;
        wren_i = 1;
        be_i = 2'b11;
        #1;
        #1;

        check_outputs(16'hAA00);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        address_i = 18'h0000D;

        data_i = 16'h1234;
        wren_i = 0;
        be_i = 2'b00;
        @(posedge clk_i);
        #2;

        data_i = 16'h5678;
        wren_i = 1;
        be_i = 2'b00;
        @(posedge clk_i);
        #2;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        address_i = 18'h0000E;

        data_i = 16'hCAFE;
        wren_i = 0;
        be_i = 2'b00;
        @(posedge clk_i);
        #2;

        data_i = 16'hBABE;
        wren_i = 0;
        be_i = 2'b11;
        @(posedge clk_i);
        #2;
        #1;

        check_outputs(16'hCAFE);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        address_i = 18'h00100;
        data_i = 16'h1111;
        wren_i = 0;
        be_i = 2'b00;
        @(posedge clk_i);
        #2;

        address_i = 18'h00200;
        data_i = 16'h2222;
        @(posedge clk_i);
        #2;

        wren_i = 1;
        address_i = 18'h00100;
        #5;
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        address_i = 18'h0000F;

        data_i = 16'h0077;
        wren_i = 0;
        be_i = 2'b10;
        @(posedge clk_i);
        #2;

        data_i = 16'h8800;
        be_i = 2'b01;
        @(posedge clk_i);
        #2;
        wren_i = 1;
        be_i = 2'b11;
        #1;
        #1;

        check_outputs(16'h8877);
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
        input [15:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,address_i, be_i, clk_i, data_i, wren_i, data_o);
    end

endmodule
