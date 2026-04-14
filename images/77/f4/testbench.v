`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] MDR_data;
    reg Mem_write_enable;
    wire [31:0] BusData_out;
    wire [31:0] Mdata_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MDR_data(MDR_data),
        .Mem_write_enable(Mem_write_enable),
        .BusData_out(BusData_out),
        .Mdata_out(Mdata_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros - Write Enable Low", test_num);
        MDR_data = 32'h0000_0000;
        Mem_write_enable = 1'b0;

        #1;


        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones - Write Enable High", test_num);
        MDR_data = 32'hFFFF_FFFF;
        Mem_write_enable = 1'b1;
        #1;

        check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits (A) - Write Enable Low", test_num);
        MDR_data = 32'hAAAA_AAAA;
        Mem_write_enable = 1'b0;
        #1;

        check_outputs(32'hAAAA_AAAA, 32'hAAAA_AAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits (5) - Write Enable High", test_num);
        MDR_data = 32'h5555_5555;
        Mem_write_enable = 1'b1;
        #1;

        check_outputs(32'h5555_5555, 32'h5555_5555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hex Pattern DEADBEEF", test_num);
        MDR_data = 32'hDEAD_BEEF;
        Mem_write_enable = 1'b1;
        #1;

        check_outputs(32'hDEAD_BEEF, 32'hDEAD_BEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hex Pattern CAFEBABE - Write Enable Low", test_num);
        MDR_data = 32'hCAFE_BABE;
        Mem_write_enable = 1'b0;
        #1;

        check_outputs(32'hCAFE_BABE, 32'hCAFE_BABE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit Walking Pattern", test_num);
        MDR_data = 32'h0000_0001;
        Mem_write_enable = 1'b1;
        #1;

        check_outputs(32'h0000_0001, 32'h0000_0001);
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
        input [31:0] expected_BusData_out;
        input [31:0] expected_Mdata_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BusData_out === (expected_BusData_out ^ BusData_out ^ expected_BusData_out) &&
                expected_Mdata_out === (expected_Mdata_out ^ Mdata_out ^ expected_Mdata_out)) begin
                $display("PASS");
                $display("  Outputs: BusData_out=%h, Mdata_out=%h",
                         BusData_out, Mdata_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusData_out=%h, Mdata_out=%h",
                         expected_BusData_out, expected_Mdata_out);
                $display("  Got:      BusData_out=%h, Mdata_out=%h",
                         BusData_out, Mdata_out);
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
