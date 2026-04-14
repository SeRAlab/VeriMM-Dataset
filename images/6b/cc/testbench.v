`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] address_in;
    reg [7:0] bank;
    reg c1;
    reg c3;
    reg clk28m;
    reg [15:0] data_in;
    reg hwr;
    reg lwr;
    reg [15:0] ramdata_in;
    reg rd;
    wire _bhe;
    wire _ble;
    wire _oe;
    wire _we;
    wire [20:0] address;
    wire [15:0] data;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_in(address_in),
        .bank(bank),
        .c1(c1),
        .c3(c3),
        .clk28m(clk28m),
        .data_in(data_in),
        .hwr(hwr),
        .lwr(lwr),
        .ramdata_in(ramdata_in),
        .rd(rd),
        ._bhe(_bhe),
        ._ble(_ble),
        ._oe(_oe),
        ._we(_we),
        .address(address),
        .data(data),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk28m = 0;
        forever #5 clk28m = ~clk28m;
    end

        task reset_dut;

        begin
            address_in = 0;
            bank = 0;
            c1 = 0;
            c3 = 0;
            data_in = 0;
            hwr = 0;
            lwr = 0;
            ramdata_in = 0;
            rd = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Read Cycle", test_num);
            reset_dut();


            bank = 8'h05;
            address_in = 18'h12345;
            rd = 1;
            ramdata_in = 16'hA5A5;


            @(posedge clk28m);
            c1 = 1;
            @(posedge clk28m);
            c3 = 1;
            @(posedge clk28m);





            #1;






            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 21'h152345, 16'hzzzz, 16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Word Write Cycle", test_num);
            reset_dut();

            bank = 8'h02;
            address_in = 18'h0ABCD;
            data_in = 16'h1234;
            hwr = 1;
            lwr = 1;

            @(posedge clk28m);
            c1 = 1;
            @(posedge clk28m);
            c3 = 1;
            @(posedge clk28m);


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 21'h08ABCD, 16'h1234, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low Byte Write Cycle", test_num);
            reset_dut();

            bank = 8'h01;
            address_in = 18'h3FFFF;
            data_in = 16'hFF55;
            hwr = 0;
            lwr = 1;

            @(posedge clk28m);
            c1 = 1;
            @(posedge clk28m);
            c3 = 1;
            @(posedge clk28m);


            #1;



            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 21'h07FFFF, 16'hFF55, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Byte Write Cycle", test_num);
            reset_dut();

            bank = 8'h07;
            address_in = 18'h00001;
            data_in = 16'hAA00;
            hwr = 1;
            lwr = 0;

            @(posedge clk28m);
            c1 = 1;
            @(posedge clk28m);
            c3 = 1;
            @(posedge clk28m);


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 21'h1C0001, 16'hAA00, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State", test_num);
            reset_dut();

            bank = 8'h00;
            address_in = 18'h00000;
            rd = 0;
            hwr = 0;
            lwr = 0;

            @(posedge clk28m);


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 21'h000000, 16'hzzzz, 16'h0000);
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
        input expected__bhe;
        input expected__ble;
        input expected__oe;
        input expected__we;
        input [20:0] expected_address;
        input [15:0] expected_data;
        input [15:0] expected_data_out;
        begin
            if (expected__bhe === (expected__bhe ^ _bhe ^ expected__bhe) &&
                expected__ble === (expected__ble ^ _ble ^ expected__ble) &&
                expected__oe === (expected__oe ^ _oe ^ expected__oe) &&
                expected__we === (expected__we ^ _we ^ expected__we) &&
                expected_address === (expected_address ^ address ^ expected_address) &&
                expected_data === (expected_data ^ data ^ expected_data) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: _bhe=%b, _ble=%b, _oe=%b, _we=%b, address=%h, data=%h, data_out=%h",
                         _bhe, _ble, _oe, _we, address, data, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _bhe=%b, _ble=%b, _oe=%b, _we=%b, address=%h, data=%h, data_out=%h",
                         expected__bhe, expected__ble, expected__oe, expected__we, expected_address, expected_data, expected_data_out);
                $display("  Got:      _bhe=%b, _ble=%b, _oe=%b, _we=%b, address=%h, data=%h, data_out=%h",
                         _bhe, _ble, _oe, _we, address, data, data_out);
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
        $dumpvars(0,address_in, bank, c1, c3, clk28m, data_in, hwr, lwr, ramdata_in, rd, _bhe, _ble, _oe, _we, address, data, data_out);
    end

endmodule
