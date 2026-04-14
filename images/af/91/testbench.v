`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_i00;
    reg [7:0] data_i01;
    reg [7:0] data_i02;
    reg [7:0] data_i03;
    reg [7:0] data_i04;
    reg [7:0] data_i05;
    reg [7:0] data_i06;
    reg [7:0] data_i07;
    reg [7:0] data_i08;
    reg [7:0] data_i09;
    reg [7:0] data_i10;
    reg [7:0] data_i11;
    reg [7:0] data_i12;
    reg [7:0] data_i13;
    reg [7:0] data_i14;
    reg [7:0] data_i15;
    reg [3:0] select;
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
        .data_i04(data_i04),
        .data_i05(data_i05),
        .data_i06(data_i06),
        .data_i07(data_i07),
        .data_i08(data_i08),
        .data_i09(data_i09),
        .data_i10(data_i10),
        .data_i11(data_i11),
        .data_i12(data_i12),
        .data_i13(data_i13),
        .data_i14(data_i14),
        .data_i15(data_i15),
        .select(select),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select data_i00", test_num);
            data_i00 = 8'hA0; data_i01 = 8'hB1; data_i02 = 8'hC2; data_i03 = 8'hD3;
            data_i04 = 8'hE4; data_i05 = 8'hF5; data_i06 = 8'h06; data_i07 = 8'h17;
            data_i08 = 8'h28; data_i09 = 8'h39; data_i10 = 8'h4A; data_i11 = 8'h5B;
            data_i12 = 8'h6C; data_i13 = 8'h7D; data_i14 = 8'h8E; data_i15 = 8'h9F;
            select = 4'd0;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select data_i05", test_num);
            select = 4'd5;
            #1;

            check_outputs(8'hF5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select data_i10", test_num);
            select = 4'd10;
            #1;

            check_outputs(8'h4A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select data_i15", test_num);
            select = 4'd15;
            #1;

            check_outputs(8'h9F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Modify data_i03 and select it", test_num);
            data_i03 = 8'h33;
            select = 4'd3;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select data_i08", test_num);
            select = 4'd8;
            #1;

            check_outputs(8'h28);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Select data_i12", test_num);
            select = 4'd12;
            #1;

            check_outputs(8'h6C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: All inputs same value, check select 7", test_num);
            data_i00 = 8'hFF; data_i01 = 8'hFF; data_i02 = 8'hFF; data_i03 = 8'hFF;
            data_i04 = 8'hFF; data_i05 = 8'hFF; data_i06 = 8'hFF; data_i07 = 8'hFF;
            data_i08 = 8'hFF; data_i09 = 8'hFF; data_i10 = 8'hFF; data_i11 = 8'hFF;
            data_i12 = 8'hFF; data_i13 = 8'hFF; data_i14 = 8'hFF; data_i15 = 8'hFF;
            select = 4'd7;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Select data_i01 with unique value", test_num);
            data_i01 = 8'h11;
            select = 4'd1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Select data_i14", test_num);
            data_i14 = 8'hEE;
            select = 4'd14;
            #1;

            check_outputs(8'hEE);
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
