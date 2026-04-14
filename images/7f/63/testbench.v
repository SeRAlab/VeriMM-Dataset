`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUCtrl_i;
    reg [31:0] data1_i;
    reg [31:0] data2_i;
    wire Zero_o;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUCtrl_i(ALUCtrl_i),
        .data1_i(data1_i),
        .data2_i(data2_i),
        .Zero_o(Zero_o),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Basic)", test_num);
            ALUCtrl_i = 4'b0010;
            data1_i = 32'h0000_1234;
            data2_i = 32'h0000_1111;
            #1;

            check_outputs(1'b0, 32'h0000_2345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Zero/Wrap)", test_num);
            ALUCtrl_i = 4'b0010;
            data1_i = 32'hFFFF_FFFF;
            data2_i = 32'h0000_0001;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Basic)", test_num);
            ALUCtrl_i = 4'b0110;
            data1_i = 32'h0000_0050;
            data2_i = 32'h0000_0020;
            #1;

            check_outputs(1'b0, 32'h0000_0030);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Zero)", test_num);
            ALUCtrl_i = 4'b0110;
            data1_i = 32'h1234_5678;
            data2_i = 32'h1234_5678;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical AND", test_num);
            ALUCtrl_i = 4'b0000;
            data1_i = 32'hAAAA_AAAA;
            data2_i = 32'hF0F0_F0F0;
            #1;

            check_outputs(1'b0, 32'hA0A0_A0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical OR", test_num);
            ALUCtrl_i = 4'b0001;
            data1_i = 32'h1234_0000;
            data2_i = 32'h0000_5678;
            #1;

            check_outputs(1'b0, 32'h1234_5678);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (Small)", test_num);
            ALUCtrl_i = 4'b0011;
            data1_i = 32'h0000_000C;
            data2_i = 32'h0000_000A;
            #1;

            check_outputs(1'b0, 32'h0000_0078);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (Truncation)", test_num);
            ALUCtrl_i = 4'b0011;
            data1_i = 32'h0001_0000;
            data2_i = 32'h0001_0000;

            #1;


            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Default Operation (Undefined Code)", test_num);
            ALUCtrl_i = 4'b1111;
            data1_i = 32'h0000_0005;
            data2_i = 32'h0000_0005;
            #1;

            check_outputs(1'b0, 32'h0000_000A);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND Result Zero", test_num);
            ALUCtrl_i = 4'b0000;
            data1_i = 32'hAAAA_AAAA;
            data2_i = 32'h5555_5555;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
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
        testcase009();
        testcase010();
        
        
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
        input expected_Zero_o;
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Zero_o === (expected_Zero_o ^ Zero_o ^ expected_Zero_o) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: Zero_o=%b, data_o=%h",
                         Zero_o, data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Zero_o=%b, data_o=%h",
                         expected_Zero_o, expected_data_o);
                $display("  Got:      Zero_o=%b, data_o=%h",
                         Zero_o, data_o);
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
