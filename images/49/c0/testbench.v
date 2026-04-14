`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en1;
    reg in1;
    reg in2;
    reg ven1;
    reg [1:0] ven2;
    reg [1:0] vin1;
    reg [1:0] vin2;
    reg [1:0] vin3;
    reg [1:0] vin4;
    wire out;
    wire [1:0] vout1;
    wire [1:0] vout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en1(en1),
        .in1(in1),
        .in2(in2),
        .ven1(ven1),
        .ven2(ven2),
        .vin1(vin1),
        .vin2(vin2),
        .vin3(vin3),
        .vin4(vin4),
        .out(out),
        .vout1(vout1),
        .vout2(vout2)
    );
    task testcase001;

        begin
            test_num = 1;

            en1 = 1; in1 = 1; in2 = 0;

            ven1 = 1; vin1 = 2'b11; vin2 = 2'b00;
            ven2 = 2'b00; vin3 = 2'b01; vin4 = 2'b10;

            #1;


            check_outputs(1'b1, 2'b11, 2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            en1 = 0; in1 = 1; in2 = 0;
            ven1 = 1; vin1 = 2'b11; vin2 = 2'b00;
            ven2 = 2'b00; vin3 = 2'b01; vin4 = 2'b10;

            #1;


            check_outputs(1'b0, 2'b11, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            en1 = 1; in1 = 0; in2 = 0;
            ven1 = 1; vin1 = 2'b10; vin2 = 2'b01;
            ven2 = 2'b01; vin3 = 2'b11; vin4 = 2'b00;

            #1;


            check_outputs(1'b0, 2'b10, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            en1 = 1; in1 = 0; in2 = 0;
            ven1 = 0; vin1 = 2'b10; vin2 = 2'b01;
            ven2 = 2'b01; vin3 = 2'b11; vin4 = 2'b00;

            #1;


            check_outputs(1'b0, 2'b01, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            en1 = 0; in1 = 0; in2 = 0;
            ven1 = 0; vin1 = 2'b00; vin2 = 2'b01; vin3 = 2'b10; vin4 = 2'b11;
            ven2 = 2'b00;

            #1;


            check_outputs(1'b0, 2'b01, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            en1 = 0; in1 = 0; in2 = 0;
            ven1 = 0; vin1 = 2'b00; vin2 = 2'b01; vin3 = 2'b10; vin4 = 2'b11;
            ven2 = 2'b01;

            #1;


            check_outputs(1'b0, 2'b01, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            en1 = 0; in1 = 0; in2 = 0;
            ven1 = 0; vin1 = 2'b00; vin2 = 2'b01; vin3 = 2'b10; vin4 = 2'b11;
            ven2 = 2'b10;

            #1;


            check_outputs(1'b0, 2'b01, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;

            en1 = 0; in1 = 0; in2 = 0;
            ven1 = 0; vin1 = 2'b00; vin2 = 2'b01; vin3 = 2'b10; vin4 = 2'b11;
            ven2 = 2'b11;

            #1;


            check_outputs(1'b0, 2'b01, 2'b11);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            en1 = 1; in1 = 1; in2 = 1;
            ven1 = 1; vin1 = 2'b11; vin2 = 2'b11;
            ven2 = 2'b10; vin3 = 2'b11; vin4 = 2'b11;

            #1;


            check_outputs(1'b1, 2'b11, 2'b11);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            en1 = 0; in1 = 1; in2 = 1;
            ven1 = 1; vin1 = 2'b01; vin2 = 2'b10;
            ven2 = 2'b11; vin3 = 2'b00; vin4 = 2'b10;

            #1;


            check_outputs(1'b1, 2'b01, 2'b10);
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
        input expected_out;
        input [1:0] expected_vout1;
        input [1:0] expected_vout2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_vout1 === (expected_vout1 ^ vout1 ^ expected_vout1) &&
                expected_vout2 === (expected_vout2 ^ vout2 ^ expected_vout2)) begin
                $display("PASS");
                $display("  Outputs: out=%b, vout1=%h, vout2=%h",
                         out, vout1, vout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, vout1=%h, vout2=%h",
                         expected_out, expected_vout1, expected_vout2);
                $display("  Got:      out=%b, vout1=%h, vout2=%h",
                         out, vout1, vout2);
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
