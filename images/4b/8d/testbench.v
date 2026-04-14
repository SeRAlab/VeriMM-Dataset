`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data1_i;
    reg [31:0] data2_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1_i(data1_i),
        .data2_i(data2_i),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero addition", test_num);
            data1_i = 32'h00000000;
            data2_i = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple addition", test_num);
            data1_i = 32'h00000005;
            data2_i = 32'h0000000A;
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Addition with overflow (32-bit wrap-around)", test_num);
            data1_i = 32'hFFFFFFFF;
            data2_i = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Alternating bits", test_num);
            data1_i = 32'h55555555;
            data2_i = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum sum wrap-around", test_num);
            data1_i = 32'hFFFFFFFF;
            data2_i = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Large value addition", test_num);
            data1_i = 32'h12345678;
            data2_i = 32'h87654321;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Adding to zero", test_num);
            data1_i = 32'hDEADBEEF;
            data2_i = 32'h00000000;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary carry into upper bits", test_num);
            data1_i = 32'h0000FFFF;
            data2_i = 32'h00000001;
            #1;

            check_outputs(32'h00010000);
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
        testcase008();
        
        
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
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
