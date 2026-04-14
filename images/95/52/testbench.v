`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_data;
    wire [63:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_data(input_data),
        .output_data(output_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 30=0, Range 20:12 Positive", test_num);
            input_data = 32'h0000_0000;
            input_data[30] = 1'b0;
            input_data[20:12] = 9'h0A5;
            #1;

            check_outputs(64'h0000_0000_0000_00A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 30=0, Range 20:12 Negative", test_num);
            input_data = 32'h0000_0000;
            input_data[30] = 1'b0;
            input_data[20:12] = 9'h15A;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FF5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 30=1, Range 23:5 Negative", test_num);
            input_data = 32'h0000_0000;
            input_data[30] = 1'b1;
            input_data[23:5] = 19'h40000;

            #1;


            check_outputs(64'hFFFF_FFFF_FFF4_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 30=1, Range 23:5 Positive", test_num);
            input_data = 32'h0000_0000;
            input_data[30] = 1'b1;
            input_data[23:5] = 19'h3FFFF;
            #1;

            check_outputs(64'h0000_0000_0003_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Bits One", test_num);
            input_data = 32'hFFFF_FFFF;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Bits Zero", test_num);
            input_data = 32'h0000_0000;

            #1;


            check_outputs(64'h0000_0000_0000_0000);
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
