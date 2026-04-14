`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg enable;
    reg [1:0] sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .enable(enable),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Enable Low Check", test_num);
            enable = 1'b0;
            sel = 2'b00;
            data0 = 8'hAA; data1 = 8'hBB; data2 = 8'hCC; data3 = 8'hDD;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select data0", test_num);
            enable = 1'b1;
            sel = 2'b00;
            data0 = 8'h11; data1 = 8'h22; data2 = 8'h33; data3 = 8'h44;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select data1", test_num);
            enable = 1'b1;
            sel = 2'b01;
            data0 = 8'h11; data1 = 8'h22; data2 = 8'h33; data3 = 8'h44;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select data2", test_num);
            enable = 1'b1;
            sel = 2'b10;
            data0 = 8'h11; data1 = 8'h22; data2 = 8'h33; data3 = 8'h44;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select data3", test_num);
            enable = 1'b1;
            sel = 2'b11;
            data0 = 8'h11; data1 = 8'h22; data2 = 8'h33; data3 = 8'h44;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enable toggle while sel=11", test_num);
            data3 = 8'hFF;
            sel = 2'b11;
            enable = 1'b1;
            #5;
            enable = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary values (All 1s)", test_num);
            enable = 1'b1;
            sel = 2'b01;
            data0 = 8'h00; data1 = 8'hFF; data2 = 8'h00; data3 = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Dynamic data change", test_num);
            enable = 1'b1;
            sel = 2'b10;
            data2 = 8'hA5;
            #5;
            data2 = 8'h5A;
            #1;

            check_outputs(8'h5A);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
