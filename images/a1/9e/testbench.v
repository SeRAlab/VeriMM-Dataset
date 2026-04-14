`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] d_address;
    reg [1:0] store_size;
    reg [31:0] write_data;
    wire [3:0] d_byteena;
    wire [31:0] d_writedataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_address(d_address),
        .store_size(store_size),
        .write_data(write_data),
        .d_byteena(d_byteena),
        .d_writedataout(d_writedataout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Store Word (Aligned)", test_num);
        write_data = 32'hAABBCCDD;
        d_address = 2'b00;
        store_size = 2'b10;
        #1;

        check_outputs(4'b1111, 32'hAABBCCDD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Store Halfword (Addr 0)", test_num);
        write_data = 32'h12345678;
        d_address = 2'b00;
        store_size = 2'b01;
        #1;

        check_outputs(4'b0011, 32'h00005678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Store Halfword (Addr 2)", test_num);
        write_data = 32'h12345678;
        d_address = 2'b10;
        store_size = 2'b01;
        #1;

        check_outputs(4'b1100, 32'h56780000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Store Byte (Addr 0)", test_num);
        write_data = 32'h12345678;
        d_address = 2'b00;
        store_size = 2'b00;
        #1;

        check_outputs(4'b0001, 32'h00000078);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Store Byte (Addr 1)", test_num);
        write_data = 32'h12345678;
        d_address = 2'b01;
        store_size = 2'b00;
        #1;

        check_outputs(4'b0010, 32'h00007800);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Store Byte (Addr 2)", test_num);
        write_data = 32'h12345678;
        d_address = 2'b10;
        store_size = 2'b00;
        #1;

        check_outputs(4'b0100, 32'h00780000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Store Byte (Addr 3)", test_num);
        write_data = 32'h12345678;
        d_address = 2'b11;
        store_size = 2'b00;
        #1;

        check_outputs(4'b1000, 32'h78000000);
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
        input [3:0] expected_d_byteena;
        input [31:0] expected_d_writedataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_byteena === (expected_d_byteena ^ d_byteena ^ expected_d_byteena) &&
                expected_d_writedataout === (expected_d_writedataout ^ d_writedataout ^ expected_d_writedataout)) begin
                $display("PASS");
                $display("  Outputs: d_byteena=%h, d_writedataout=%h",
                         d_byteena, d_writedataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_byteena=%h, d_writedataout=%h",
                         expected_d_byteena, expected_d_writedataout);
                $display("  Got:      d_byteena=%h, d_writedataout=%h",
                         d_byteena, d_writedataout);
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
