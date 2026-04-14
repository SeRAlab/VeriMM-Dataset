`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [63:0] input_data_1;
    reg [63:0] input_data_2;
    wire [63:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_data_1(input_data_1),
        .input_data_2(input_data_2),
        .output_data(output_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic Addition", test_num);
            input_data_1 = 64'd100;
            input_data_2 = 64'd250;
            @(posedge clk);
            #1;

            check_outputs(64'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Addition with Zero", test_num);
            input_data_1 = 64'h0;
            input_data_2 = 64'hABCD_EF01_2345_6789;
            @(posedge clk);
            #1;

            check_outputs(64'hABCD_EF01_2345_6789);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: 64-bit Overflow", test_num);
            input_data_1 = 64'hFFFF_FFFF_FFFF_FFFF;
            input_data_2 = 64'h0000_0000_0000_0001;
            @(posedge clk);
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Alternating Bit Patterns", test_num);
            input_data_1 = 64'hAAAA_AAAA_AAAA_AAAA;
            input_data_2 = 64'h5555_5555_5555_5555;
            @(posedge clk);
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Large Numbers", test_num);
            input_data_1 = 64'h1234_5678_9ABC_DEF0;
            input_data_2 = 64'h1010_1010_1010_1010;
            @(posedge clk);
            #1;

            check_outputs(64'h2244_6688_AACC_EE00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Full Carry Propagation", test_num);
            input_data_1 = 64'hFFFF_FFFF_FFFF_FFFE;
            input_data_2 = 64'h0000_0000_0000_0001;
            @(posedge clk);
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
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
        input [63:0] expected_output_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
