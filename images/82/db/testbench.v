`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] AluOut;
    reg Zero;
    reg [31:0] read_data_1;
    reg [31:0] read_data_2;
    wire [31:0] read_data_1temp;
    wire [31:0] read_data_2temp;
    wire [31:0] tempAluOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AluOut(AluOut),
        .Zero(Zero),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .read_data_1temp(read_data_1temp),
        .read_data_2temp(read_data_2temp),
        .tempAluOut(tempAluOut)
    );
    task testcase001;

        begin
            test_num = 1;
            read_data_1 = 32'd50;
            read_data_2 = 32'd20;
            Zero = 1'b1;
            AluOut = 32'hDEADBEEF;
            #1;

            check_outputs(32'd50, 32'd20, 32'd31);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            read_data_1 = 32'd50;
            read_data_2 = 32'd20;
            Zero = 1'b0;
            AluOut = 32'h0;
            #1;

            check_outputs(32'd50, 32'd20, 32'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            read_data_1 = 32'd100;
            read_data_2 = 32'd100;
            Zero = 1'b1;
            AluOut = 32'h1234;
            #1;

            check_outputs(32'd100, 32'd100, 32'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            read_data_1 = 32'd100;
            read_data_2 = 32'd100;
            Zero = 1'b0;
            AluOut = 32'h1234;
            #1;

            check_outputs(32'd100, 32'd100, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            read_data_1 = 32'hFFFFFFFF;
            read_data_2 = 32'h00000000;
            Zero = 1'b1;
            AluOut = 32'h0;

            #1;


            check_outputs(32'hFFFFFFFF, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            read_data_1 = 32'h00000005;
            read_data_2 = 32'h0000000A;
            Zero = 1'b0;
            AluOut = 32'hAABBCCDD;

            #1;


            check_outputs(32'h00000005, 32'h0000000A, 32'hFFFFFFFB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            read_data_1 = 32'h80000000;
            read_data_2 = 32'h7FFFFFFF;
            Zero = 1'b1;
            AluOut = 32'h0;

            #1;


            check_outputs(32'h80000000, 32'h7FFFFFFF, 32'h00000002);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            read_data_1 = 32'h12345678;
            read_data_2 = 32'h87654321;
            Zero = 1'b0;
            AluOut = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h12345678, 32'h87654321, 32'h8ACF1357);
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
        input [31:0] expected_read_data_1temp;
        input [31:0] expected_read_data_2temp;
        input [31:0] expected_tempAluOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_read_data_1temp === (expected_read_data_1temp ^ read_data_1temp ^ expected_read_data_1temp) &&
                expected_read_data_2temp === (expected_read_data_2temp ^ read_data_2temp ^ expected_read_data_2temp) &&
                expected_tempAluOut === (expected_tempAluOut ^ tempAluOut ^ expected_tempAluOut)) begin
                $display("PASS");
                $display("  Outputs: read_data_1temp=%h, read_data_2temp=%h, tempAluOut=%h",
                         read_data_1temp, read_data_2temp, tempAluOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data_1temp=%h, read_data_2temp=%h, tempAluOut=%h",
                         expected_read_data_1temp, expected_read_data_2temp, expected_tempAluOut);
                $display("  Got:      read_data_1temp=%h, read_data_2temp=%h, tempAluOut=%h",
                         read_data_1temp, read_data_2temp, tempAluOut);
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
