`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in0;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg [7:0] data_in3;
    reg [1:0] select;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in0(data_in0),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_in3(data_in3),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select data_in0", test_num);
            data_in0 = 8'hAA;
            data_in1 = 8'hBB;
            data_in2 = 8'hCC;
            data_in3 = 8'hDD;
            select = 2'b00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select data_in1", test_num);
            data_in0 = 8'h11;
            data_in1 = 8'h22;
            data_in2 = 8'h33;
            data_in3 = 8'h44;
            select = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select data_in2", test_num);
            data_in0 = 8'h55;
            data_in1 = 8'h66;
            data_in2 = 8'h77;
            data_in3 = 8'h88;
            select = 2'b10;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select data_in3", test_num);
            data_in0 = 8'hF0;
            data_in1 = 8'h0F;
            data_in2 = 8'hA5;
            data_in3 = 8'h5A;
            select = 2'b11;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: All inputs Zero, Select 2", test_num);
            data_in0 = 8'h00;
            data_in1 = 8'h00;
            data_in2 = 8'h00;
            data_in3 = 8'h00;
            select = 2'b10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: All inputs Full, Select 0", test_num);
            data_in0 = 8'hFF;
            data_in1 = 8'hFF;
            data_in2 = 8'hFF;
            data_in3 = 8'hFF;
            select = 2'b00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Dynamic data change on selected channel", test_num);
            data_in0 = 8'h12;
            data_in1 = 8'h34;
            data_in2 = 8'h56;
            data_in3 = 8'h78;
            select = 2'b01;
            #5;
            data_in1 = 8'h9A;
            #1;

            check_outputs(8'h9A);
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
        input [7:0] expected_data_out;
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
