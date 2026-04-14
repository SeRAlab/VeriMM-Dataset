`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [3:0] vin;
    reg [3:0] vin1;
    reg [3:0] vin2;
    wire out;
    wire [3:0] vout;
    wire [3:0] vout1;
    wire [3:0] vout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .vin(vin),
        .vin1(vin1),
        .vin2(vin2),
        .out(out),
        .vout(vout),
        .vout1(vout1),
        .vout2(vout2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in = 1'b0;
            vin = 4'b0000;
            vin1 = 4'b0000;
            vin2 = 4'b0000;




            #1;





            check_outputs(1'b0, 4'b0000, 4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            in = 1'b1;
            vin = 4'b1111;
            vin1 = 4'b1111;
            vin2 = 4'b1111;




            #1;





            check_outputs(1'b0, 4'b1100, 4'b0011, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift and Logical Right Shift Patterns", test_num);
            in = 1'b1;
            vin = 4'b0011;
            vin1 = 4'b1100;
            vin2 = 4'b0100;




            #1;





            check_outputs(1'b0, 4'b1100, 4'b0011, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic Right Shift (Negative value)", test_num);
            in = 1'b0;
            vin = 4'b1010;
            vin1 = 4'b1010;
            vin2 = 4'b1010;




            #1;





            check_outputs(1'b0, 4'b1000, 4'b0010, 4'b1110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge case for Arithmetic Shift (1000)", test_num);
            in = 1'b1;
            vin = 4'b0001;
            vin1 = 4'b1000;
            vin2 = 4'b1000;




            #1;





            check_outputs(1'b0, 4'b0100, 4'b0010, 4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed patterns", test_num);
            in = 1'b1;
            vin = 4'b0101;
            vin1 = 4'b0101;
            vin2 = 4'b1101;




            #1;





            check_outputs(1'b0, 4'b0100, 4'b0001, 4'b1111);
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
        input [3:0] expected_vout;
        input [3:0] expected_vout1;
        input [3:0] expected_vout2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_vout === (expected_vout ^ vout ^ expected_vout) &&
                expected_vout1 === (expected_vout1 ^ vout1 ^ expected_vout1) &&
                expected_vout2 === (expected_vout2 ^ vout2 ^ expected_vout2)) begin
                $display("PASS");
                $display("  Outputs: out=%b, vout=%h, vout1=%h, vout2=%h",
                         out, vout, vout1, vout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, vout=%h, vout1=%h, vout2=%h",
                         expected_out, expected_vout, expected_vout1, expected_vout2);
                $display("  Got:      out=%b, vout=%h, vout1=%h, vout2=%h",
                         out, vout, vout1, vout2);
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
