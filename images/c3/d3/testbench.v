`timescale 1ns/1ps

module Mux4_tb;

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
    Mux4 dut (
        .data_i00(data_i00),
        .data_i01(data_i01),
        .data_i02(data_i02),
        .data_i03(data_i03),
        .select(select),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select data_i00 (2'b00)", test_num);
            data_i00 = 8'hA5;
            data_i01 = 8'h12;
            data_i02 = 8'h34;
            data_i03 = 8'h56;
            select   = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select data_i01 (2'b01)", test_num);
            data_i00 = 8'hA5;
            data_i01 = 8'h5A;
            data_i02 = 8'hBC;
            data_i03 = 8'hDE;
            select   = 2'b01;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select data_i02 (2'b10)", test_num);
            data_i00 = 8'h11;
            data_i01 = 8'h22;
            data_i02 = 8'h33;
            data_i03 = 8'h44;
            select   = 2'b10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select data_i03 (2'b11)", test_num);
            data_i00 = 8'h00;
            data_i01 = 8'hFF;
            data_i02 = 8'hAA;
            data_i03 = 8'h55;
            select   = 2'b11;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All inputs same value, select 10", test_num);
            data_i00 = 8'hFF;
            data_i01 = 8'hFF;
            data_i02 = 8'hFF;
            data_i03 = 8'hFF;
            select   = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All zeros check, select 01", test_num);
            data_i00 = 8'h00;
            data_i01 = 8'h00;
            data_i02 = 8'h00;
            data_i03 = 8'h00;
            select   = 2'b01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary values test (8'hFF on i00)", test_num);
            data_i00 = 8'hFF;
            data_i01 = 8'h00;
            data_i02 = 8'h00;
            data_i03 = 8'h00;
            select   = 2'b00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Alternating bit pattern test", test_num);
            data_i00 = 8'h55;
            data_i01 = 8'hAA;
            data_i02 = 8'h33;
            data_i03 = 8'hCC;
            select   = 2'b11;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Mux4 Testbench");
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
