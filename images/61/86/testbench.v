`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] master_ADDR;
    reg [31:0] master_DAT_I;
    reg master_STB;
    reg master_WE;
    reg [15:0] slave_ACK;
    reg [511:0] slave_DAT_I;
    wire master_ACK;
    wire [31:0] master_DAT_O;
    wire [31:0] slave_ADDR;
    wire [31:0] slave_DAT_O;
    wire [15:0] slave_STB;
    wire slave_WE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .master_ADDR(master_ADDR),
        .master_DAT_I(master_DAT_I),
        .master_STB(master_STB),
        .master_WE(master_WE),
        .slave_ACK(slave_ACK),
        .slave_DAT_I(slave_DAT_I),
        .master_ACK(master_ACK),
        .master_DAT_O(master_DAT_O),
        .slave_ADDR(slave_ADDR),
        .slave_DAT_O(slave_DAT_O),
        .slave_STB(slave_STB),
        .slave_WE(slave_WE)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read from Slave 0", test_num);


            master_ADDR = 32'h0000_0000;
            master_DAT_I = 32'h0000_0000;
            master_STB = 1;
            master_WE = 0;


            slave_ACK = 16'h0001;
            slave_DAT_I = 0;
            slave_DAT_I[31:0] = 32'hAABBCCDD;


            #1;



            check_outputs(
                1'b1,
                32'hAABBCCDD,
                32'h0000_0000,
                32'h0000_0000,
                16'h0001,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Slave 15", test_num);


            master_ADDR = 32'hF000_ABCD;
            master_DAT_I = 32'h1234_5678;
            master_STB = 1;
            master_WE = 1;


            slave_ACK = 16'h8000;
            slave_DAT_I = 0;
            slave_DAT_I[511:480] = 32'hDEAD_BEEF;


            #1;



            check_outputs(
                1'b1,
                32'hDEAD_BEEF,
                32'hF000_ABCD,
                32'h1234_5678,
                16'h8000,
                1'b1
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read from Slave 5, No ACK", test_num);


            master_ADDR = 32'h5000_0000;
            master_DAT_I = 32'h0000_0000;
            master_STB = 1;
            master_WE = 0;


            slave_ACK = 16'h0000;
            slave_DAT_I = 0;
            slave_DAT_I[191:160] = 32'h5555_AAAA;

            #1;


            check_outputs(
                1'b0,
                32'h5555_AAAA,
                32'h5000_0000,
                32'h0000_0000,
                16'h0020,
                1'b0
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Master STB Inactive", test_num);

            master_ADDR = 32'h8000_0000;
            master_DAT_I = 32'hFFFF_FFFF;
            master_STB = 0;
            master_WE = 1;

            slave_ACK = 16'hFFFF;
            slave_DAT_I = 0;


            #1;



            check_outputs(
                1'b0,
                32'h0000_0000,
                32'h8000_0000,
                32'hFFFF_FFFF,
                16'h0000,
                1'b1
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Slave 1", test_num);

            master_ADDR = 32'h1000_0000;
            master_STB = 1;
            master_WE = 0;

            slave_ACK = 16'h0002;
            slave_DAT_I = 0;
            slave_DAT_I[63:32] = 32'h1111_1111;
            slave_DAT_I[31:0]  = 32'hEEEE_EEEE;

            #1;


            check_outputs(
                1'b1,
                32'h1111_1111,
                32'h1000_0000,
                32'h0000_0000,
                16'h0002,
                1'b0
            );
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
        input expected_master_ACK;
        input [31:0] expected_master_DAT_O;
        input [31:0] expected_slave_ADDR;
        input [31:0] expected_slave_DAT_O;
        input [15:0] expected_slave_STB;
        input expected_slave_WE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_master_ACK === (expected_master_ACK ^ master_ACK ^ expected_master_ACK) &&
                expected_master_DAT_O === (expected_master_DAT_O ^ master_DAT_O ^ expected_master_DAT_O) &&
                expected_slave_ADDR === (expected_slave_ADDR ^ slave_ADDR ^ expected_slave_ADDR) &&
                expected_slave_DAT_O === (expected_slave_DAT_O ^ slave_DAT_O ^ expected_slave_DAT_O) &&
                expected_slave_STB === (expected_slave_STB ^ slave_STB ^ expected_slave_STB) &&
                expected_slave_WE === (expected_slave_WE ^ slave_WE ^ expected_slave_WE)) begin
                $display("PASS");
                $display("  Outputs: master_ACK=%b, master_DAT_O=%h, slave_ADDR=%h, slave_DAT_O=%h, slave_STB=%h, slave_WE=%b",
                         master_ACK, master_DAT_O, slave_ADDR, slave_DAT_O, slave_STB, slave_WE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: master_ACK=%b, master_DAT_O=%h, slave_ADDR=%h, slave_DAT_O=%h, slave_STB=%h, slave_WE=%b",
                         expected_master_ACK, expected_master_DAT_O, expected_slave_ADDR, expected_slave_DAT_O, expected_slave_STB, expected_slave_WE);
                $display("  Got:      master_ACK=%b, master_DAT_O=%h, slave_ADDR=%h, slave_DAT_O=%h, slave_STB=%h, slave_WE=%b",
                         master_ACK, master_DAT_O, slave_ADDR, slave_DAT_O, slave_STB, slave_WE);
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
