`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] address_bus;
    reg ce_n;
    reg read_n;
    reg write_n;
    wire ce2;
    wire ceh_n;
    wire [16:0] mem_address;
    wire oe_n;
    wire we_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_bus(address_bus),
        .ce_n(ce_n),
        .read_n(read_n),
        .write_n(write_n),
        .ce2(ce2),
        .ceh_n(ceh_n),
        .mem_address(mem_address),
        .oe_n(oe_n),
        .we_n(we_n)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Chip Disabled Logic", test_num);

            ce_n = 1'b1;
            read_n = 1'b1;
            write_n = 1'b1;
            address_bus = 7'h00;


            #1;



            check_outputs(1'b0, 1'b0, 17'h00000, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Read Operation at Address 0x5A", test_num);
            ce_n = 1'b0;
            read_n = 1'b0;
            write_n = 1'b1;
            address_bus = 7'h5A;


            #1;



            check_outputs(1'b1, 1'b0, 17'h0005A, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write Operation at Address 0x23", test_num);
            ce_n = 1'b0;
            read_n = 1'b1;
            write_n = 1'b0;
            address_bus = 7'h23;


            #1;



            check_outputs(1'b1, 1'b0, 17'h00023, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Enabled Idle State", test_num);
            ce_n = 1'b0;
            read_n = 1'b1;
            write_n = 1'b1;
            address_bus = 7'h12;


            #1;



            check_outputs(1'b1, 1'b0, 17'h00012, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Max Address Mapping", test_num);
            ce_n = 1'b0;
            read_n = 1'b0;
            write_n = 1'b1;
            address_bus = 7'h7F;


            #1;



            check_outputs(1'b1, 1'b0, 17'h0007F, 1'b0, 1'b1);
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
        input expected_ce2;
        input expected_ceh_n;
        input [16:0] expected_mem_address;
        input expected_oe_n;
        input expected_we_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ce2 === (expected_ce2 ^ ce2 ^ expected_ce2) &&
                expected_ceh_n === (expected_ceh_n ^ ceh_n ^ expected_ceh_n) &&
                expected_mem_address === (expected_mem_address ^ mem_address ^ expected_mem_address) &&
                expected_oe_n === (expected_oe_n ^ oe_n ^ expected_oe_n) &&
                expected_we_n === (expected_we_n ^ we_n ^ expected_we_n)) begin
                $display("PASS");
                $display("  Outputs: ce2=%b, ceh_n=%b, mem_address=%h, oe_n=%b, we_n=%b",
                         ce2, ceh_n, mem_address, oe_n, we_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce2=%b, ceh_n=%b, mem_address=%h, oe_n=%b, we_n=%b",
                         expected_ce2, expected_ceh_n, expected_mem_address, expected_oe_n, expected_we_n);
                $display("  Got:      ce2=%b, ceh_n=%b, mem_address=%h, oe_n=%b, we_n=%b",
                         ce2, ceh_n, mem_address, oe_n, we_n);
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
