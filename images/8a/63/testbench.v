`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_data;
    reg [1:0] sel;
    wire [1:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_data(in_data),
        .sel(sel),
        .out_data(out_data)
    );
    task testcase001;

        begin
            test_num = 1;
            in_data = 4'b0000;
            sel = 2'b00;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_data = 4'b0001;
            sel = 2'b00;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_data = 4'b0110;
            sel = 2'b00;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_data = 4'b1011;
            sel = 2'b00;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in_data = 4'b0001;
            sel = 2'b01;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in_data = 4'b1110;
            sel = 2'b01;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in_data = 4'b1011;
            sel = 2'b01;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in_data = 4'b1111;
            sel = 2'b10;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in_data = 4'b0101;
            sel = 2'b11;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
