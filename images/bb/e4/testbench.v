`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg load;
    reg [31:0] mem_data_in;
    reg [31:0] reg_data_in;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .load(load),
        .mem_data_in(mem_data_in),
        .reg_data_in(reg_data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both control signals LOW", test_num);
            reg_data_in = 32'hAAAA_AAAA;
            mem_data_in = 32'h5555_5555;
            load = 0;
            enable = 0;

            #1;


            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only enable HIGH", test_num);
            reg_data_in = 32'h1234_5678;
            mem_data_in = 32'h8765_4321;
            load = 0;
            enable = 1;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only load HIGH", test_num);
            reg_data_in = 32'hDEAD_BEEF;
            mem_data_in = 32'hCAFE_BABE;
            load = 1;
            enable = 0;

            #1;


            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both load and enable HIGH", test_num);
            reg_data_in = 32'h0000_FFFF;
            mem_data_in = 32'hFFFF_0000;
            load = 1;
            enable = 1;

            #1;


            check_outputs(32'hFFFF_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Selecting All Zeros from Memory", test_num);
            reg_data_in = 32'hFFFF_FFFF;
            mem_data_in = 32'h0000_0000;
            load = 1;
            enable = 1;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Defaulting to All Ones from Registers", test_num);
            reg_data_in = 32'hFFFF_FFFF;
            mem_data_in = 32'h0000_0000;
            load = 0;
            enable = 1;

            #1;


            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large values selection", test_num);
            reg_get_data: reg_data_in = 32'hF0F0_F0F0;
            mem_data_in = 32'h0F0F_0F0F;
            load = 1;
            enable = 1;

            #1;


            check_outputs(32'h0F0F_0F0F);
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
        input [31:0] expected_data_out;
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
