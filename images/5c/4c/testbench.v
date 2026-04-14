`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_i00;
    reg [7:0] data_i01;
    reg [7:0] data_i02;
    reg [7:0] data_i03;
    reg [1:0] select;
    wire [7:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_i00(data_i00),
        .data_i01(data_i01),
        .data_i02(data_i02),
        .data_i03(data_i03),
        .select(select),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data_i00", test_num);
            select = 2'b00;
            data_i00 = 8'hA5;
            data_i01 = 8'h00;
            data_i02 = 8'h00;
            data_i03 = 8'h00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data_i01", test_num);
            select = 2'b01;
            data_i00 = 8'h00;
            data_i01 = 8'h5A;
            data_i02 = 8'h00;
            data_i03 = 8'h00;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data_i02", test_num);
            select = 2'b10;
            data_i00 = 8'h00;
            data_i01 = 8'h00;
            data_i02 = 8'hFF;
            data_i03 = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data_i03", test_num);
            select = 2'b11;
            data_i00 = 8'h00;
            data_i01 = 8'h00;
            data_i02 = 8'h00;
            data_i03 = 8'hC3;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Switch selection with active data", test_num);
            data_i00 = 8'h11;
            data_i01 = 8'h22;
            data_i02 = 8'h33;
            data_i03 = 8'h44;


            select = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check all-ones data", test_num);
            data_i00 = 8'hFF;
            data_i01 = 8'hFF;
            data_i02 = 8'hFF;
            data_i03 = 8'hFF;
            select = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check all-zeros data", test_num);
            data_i00 = 8'h00;
            data_i01 = 8'h00;
            data_i02 = 8'h00;
            data_i03 = 8'h00;
            select = 2'b00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High-bit data test", test_num);
            data_i00 = 8'h80;
            data_i01 = 8'h01;
            data_i02 = 8'hAA;
            data_i03 = 8'h55;
            select = 2'b11;
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_data_o;
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
