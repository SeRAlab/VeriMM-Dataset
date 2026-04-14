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
            $display("Testcase %0d: Select data_i00", test_num);
            data_i00 = 8'h00; data_i01 = 8'h11; data_i02 = 8'h22; data_i03 = 8'h33;
            data_i04 = 8'h44; data_i05 = 8'h55; data_i06 = 8'h66; data_i07 = 8'h77;
            data_i08 = 8'h88; data_i09 = 8'h99; data_i10 = 8'hAA; data_i11 = 8'hBB;
            data_i12 = 8'hCC; data_i13 = 8'hDD; data_i14 = 8'hEE; data_i15 = 8'hFF;
            select = 4'd0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select data_i01", test_num);
            select = 4'd1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select data_i02", test_num);
            select = 4'd2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select data_i03", test_num);
            select = 4'd3;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select data_i04", test_num);
            select = 4'd4;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select data_i05", test_num);
            select = 4'd5;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select data_i06", test_num);
            select = 4'd6;
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select data_i07", test_num);
            select = 4'd7;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Select data_i08", test_num);
            select = 4'd8;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Select data_i09", test_num);
            select = 4'd9;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Select data_i10", test_num);
            select = 4'd10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Select data_i11", test_num);
            select = 4'd11;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Testcase %0d: Select data_i12", test_num);
            select = 4'd12;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Testcase %0d: Select data_i13", test_num);
            select = 4'd13;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Testcase %0d: Select data_i14", test_num);
            select = 4'd14;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Testcase %0d: Select data_i15", test_num);
            select = 4'd15;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase017;

        begin
            test_num = 17;
            $display("Testcase %0d: All inputs same (AA), Select 7", test_num);
            data_i00 = 8'hAA; data_i01 = 8'hAA; data_i02 = 8'hAA; data_i03 = 8'hAA;
            data_i04 = 8'hAA; data_i05 = 8'hAA; data_i06 = 8'hAA; data_i07 = 8'hAA;
            data_i08 = 8'hAA; data_i09 = 8'hAA; data_i10 = 8'hAA; data_i11 = 8'hAA;
            data_i12 = 8'hAA; data_i13 = 8'hAA; data_i14 = 8'hAA; data_i15 = 8'hAA;
            select = 4'd7;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase018;

        begin
            test_num = 18;
            $display("Testcase %0d: Update data while selected", test_num);
            select = 4'd10;
            data_i10 = 8'h55;
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        
        
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
