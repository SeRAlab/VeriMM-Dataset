`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] memory_data_out;
    reg read_enable;
    reg [31:0] virtual_address;
    reg write_enable;
    wire [31:0] memory_data_in;
    wire [31:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .memory_data_out(memory_data_out),
        .read_enable(read_enable),
        .virtual_address(virtual_address),
        .write_enable(write_enable),
        .memory_data_in(memory_data_in),
        .physical_address(physical_address)
    );
    task testcase001;

    begin
        test_num = 1;
        virtual_address = 32'h00000010;
        write_enable = 1;
        read_enable = 0;
        memory_data_out = 32'hCAFE_BABE;
        #1;

        check_outputs(32'h00000010, virtual_address + BASE_ADDR);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        virtual_address = 32'h00000ABC;
        write_enable = 0;
        read_enable = 1;
        memory_data_out = 32'h1234_5678;
        #1;

        check_outputs(32'h1234_5678, virtual_address + BASE_ADDR);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        virtual_address = 32'h0000_FFFF;
        write_enable = 0;
        read_enable = 0;
        memory_data_out = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h0000_0000, virtual_address + BASE_ADDR);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        virtual_address = 32'h0000_0000;
        write_enable = 1;
        read_enable = 0;
        memory_data_out = 32'h0;
        #1;

        check_outputs(32'h0000_0000, BASE_ADDR);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        virtual_address = 32'hFFFF_FFFF;
        write_enable = 0;
        read_enable = 1;
        memory_data_out = 32'hAAAA_5555;

        #1;


        check_outputs(32'hAAAA_5555, 32'h0000_0FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        virtual_address = 32'h0000_55AA;
        write_enable = 1;
        read_enable = 1;
        memory_data_out = 32'h1111_2222;
        #1;

        check_outputs(32'h0000_55AA, virtual_address + BASE_ADDR);
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
        input [31:0] expected_memory_data_in;
        input [31:0] expected_physical_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_memory_data_in === (expected_memory_data_in ^ memory_data_in ^ expected_memory_data_in) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: memory_data_in=%h, physical_address=%h",
                         memory_data_in, physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_data_in=%h, physical_address=%h",
                         expected_memory_data_in, expected_physical_address);
                $display("  Got:      memory_data_in=%h, physical_address=%h",
                         memory_data_in, physical_address);
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
