`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bus_in;
    wire [7:0] bus_out;
    wire [1:0] selected_bits_1_2;
    wire [2:0] selected_bits_3_5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus_in(bus_in),
        .bus_out(bus_out),
        .selected_bits_1_2(selected_bits_1_2),
        .selected_bits_3_5(selected_bits_3_5)
    );
    task testcase001;

    begin
        test_num = 1;
        bus_in = 8'h00;



        #1;




        check_outputs(8'h00, 2'b00, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bus_in = 8'hFF;



        #1;




        check_outputs(8'h11, 2'b11, 3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bus_in = 8'h11;



        #1;




        check_outputs(8'h11, 2'b00, 3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bus_in = 8'b0000_0110;



        #1;




        check_outputs(8'h00, 2'b11, 3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bus_in = 8'b0011_1000;



        #1;




        check_outputs(8'h10, 2'b00, 3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bus_in = 8'hAA;



        #1;




        check_outputs(8'h00, 2'b01, 3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bus_in = 8'h55;



        #1;




        check_outputs(8'h11, 2'b10, 3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bus_in = 8'h81;



        #1;




        check_outputs(8'h01, 2'b00, 3'b000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bus_in = 8'h10;



        #1;




        check_outputs(8'h10, 2'b00, 3'b010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bus_in = 8'hC0;



        #1;




        check_outputs(8'h00, 2'b00, 3'b000);
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
        input [7:0] expected_bus_out;
        input [1:0] expected_selected_bits_1_2;
        input [2:0] expected_selected_bits_3_5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bus_out === (expected_bus_out ^ bus_out ^ expected_bus_out) &&
                expected_selected_bits_1_2 === (expected_selected_bits_1_2 ^ selected_bits_1_2 ^ expected_selected_bits_1_2) &&
                expected_selected_bits_3_5 === (expected_selected_bits_3_5 ^ selected_bits_3_5 ^ expected_selected_bits_3_5)) begin
                $display("PASS");
                $display("  Outputs: bus_out=%h, selected_bits_1_2=%h, selected_bits_3_5=%h",
                         bus_out, selected_bits_1_2, selected_bits_3_5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_out=%h, selected_bits_1_2=%h, selected_bits_3_5=%h",
                         expected_bus_out, expected_selected_bits_1_2, expected_selected_bits_3_5);
                $display("  Got:      bus_out=%h, selected_bits_1_2=%h, selected_bits_3_5=%h",
                         bus_out, selected_bits_1_2, selected_bits_3_5);
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
