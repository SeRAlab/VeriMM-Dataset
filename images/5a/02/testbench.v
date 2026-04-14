`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] addr;
    reg [63:0] data_in;
    reg [1:0] datamode;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .data_in(data_in),
        .datamode(datamode),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 64'hFEDCBA98_76543210;
        addr = 3'b000;
        datamode = 2'b00;
        #1;

        check_outputs(64'hFEDCBA98_00000010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 64'hFEDCBA98_76543210;
        addr = 3'b011;
        datamode = 2'b00;
        #1;

        check_outputs(64'hFEDCBA98_00000076);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 64'hAABBCCDD_11223344;
        addr = 3'b000;
        datamode = 2'b01;
        #1;

        check_outputs(64'hAABBCCDD_00003344);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 64'hAABBCCDD_11223344;
        addr = 3'b110;
        datamode = 2'b01;
        #1;

        check_outputs(64'hAABBCCDD_0000AABB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 64'h12345678_9ABCDEF0;
        addr = 3'b000;
        datamode = 2'b10;
        #1;

        check_outputs(64'h12345678_9ABCDEF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 64'h12345678_9ABCDEF0;
        addr = 3'b100;
        datamode = 2'b10;
        #1;

        check_outputs(64'h12345678_12345678);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 64'hFF00EE11_DD22CC33;
        addr = 3'b111;
        datamode = 2'b00;
        #1;

        check_outputs(64'hFF00EE11_000000FF);
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
        input [63:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
