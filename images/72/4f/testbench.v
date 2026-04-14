`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data_i;
    reg operation;
    reg [1:0] shift_region_flag;
    wire data_out_CORDECO;
    wire sel_mux_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_i(data_i),
        .operation(operation),
        .shift_region_flag(shift_region_flag),
        .data_out_CORDECO(data_out_CORDECO),
        .sel_mux_3(sel_mux_3)
    );
    task testcase001;

    begin
        test_num = 1;
        operation = 1'b0; shift_region_flag = 2'b00; data_i = 1'b0;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        operation = 1'b0; shift_region_flag = 2'b00; data_i = 1'b1;
        #10; #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        operation = 1'b0; shift_region_flag = 2'b01; data_i = 1'b0;
        #10; #1;
 check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        operation = 1'b0; shift_region_flag = 2'b01; data_i = 1'b1;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        operation = 1'b0; shift_region_flag = 2'b10; data_i = 1'b0;
        #10; #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        operation = 1'b0; shift_region_flag = 2'b10; data_i = 1'b1;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        operation = 1'b0; shift_region_flag = 2'b11; data_i = 1'b0;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        operation = 1'b0; shift_region_flag = 2'b11; data_i = 1'b1;
        #10; #1;
 check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        operation = 1'b1; shift_region_flag = 2'b00; data_i = 1'b0;
        #10; #1;
 check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        operation = 1'b1; shift_region_flag = 2'b00; data_i = 1'b1;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        operation = 1'b1; shift_region_flag = 2'b01; data_i = 1'b0;
        #10; #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        operation = 1'b1; shift_region_flag = 2'b01; data_i = 1'b1;
        #10; #1;
 check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        operation = 1'b1; shift_region_flag = 2'b10; data_i = 1'b0;
        #10; #1;
 check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        operation = 1'b1; shift_region_flag = 2'b10; data_i = 1'b1;
        #10; #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        operation = 1'b1; shift_region_flag = 2'b11; data_i = 1'b0;
        #10; #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        operation = 1'b1; shift_region_flag = 2'b11; data_i = 1'b1;
        #10; #1;
 check_outputs(1'b0, 1'b0);
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
        input expected_data_out_CORDECO;
        input expected_sel_mux_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out_CORDECO === (expected_data_out_CORDECO ^ data_out_CORDECO ^ expected_data_out_CORDECO) &&
                expected_sel_mux_3 === (expected_sel_mux_3 ^ sel_mux_3 ^ expected_sel_mux_3)) begin
                $display("PASS");
                $display("  Outputs: data_out_CORDECO=%b, sel_mux_3=%b",
                         data_out_CORDECO, sel_mux_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_CORDECO=%b, sel_mux_3=%b",
                         expected_data_out_CORDECO, expected_sel_mux_3);
                $display("  Got:      data_out_CORDECO=%b, sel_mux_3=%b",
                         data_out_CORDECO, sel_mux_3);
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
