`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] choose;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg [7:0] in5;
    reg [7:0] in6;
    reg [7:0] in7;
    reg [7:0] in8;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose(choose),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 1: Select in1 (choose=0)");
            in1 = 8'hA1; in2 = 8'h00; in3 = 8'h00; in4 = 8'h00;
            in5 = 8'h00; in6 = 8'h00; in7 = 8'h00; in8 = 8'h00;
            choose = 3'b000;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 2: Select in2 (choose=1)");
            in1 = 8'h00; in2 = 8'hB2; in3 = 8'h00; in4 = 8'h00;
            in5 = 8'h00; in6 = 8'h00; in7 = 8'h00; in8 = 8'h00;
            choose = 3'b001;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 3: Select in3 (choose=2)");
            in1 = 8'h00; in2 = 8'h00; in3 = 8'hC3; in4 = 8'h00;
            in5 = 8'h00; in6 = 8'h00; in7 = 8'h00; in8 = 8'h00;
            choose = 3'b010;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 4: Select in4 (choose=3)");
            in1 = 8'h00; in2 = 8'h00; in3 = 8'h00; in4 = 8'hD4;
            in5 = 8'h00; in6 = 8'h00; in7 = 8'h00; in8 = 8'h00;
            choose = 3'b011;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 5: Select in5 (choose=4)");
            in1 = 8'h00; in2 = 8'h00; in3 = 8'h00; in4 = 8'h00;
            in5 = 8'hE5; in6 = 8'h00; in7 = 8'h00; in8 = 8'h00;
            choose = 3'b100;
            #1;

            check_outputs(8'hE5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 6: Select in6 (choose=5)");
            in1 = 8'h00; in2 = 8'h00; in3 = 8'h00; in4 = 8'h00;
            in5 = 8'h00; in6 = 8'hF6; in7 = 8'h00; in8 = 8'h00;
            choose = 3'b101;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 7: Select in7 (choose=6)");
            in1 = 8'h00; in2 = 8'h00; in3 = 8'h00; in4 = 8'h00;
            in5 = 8'h00; in6 = 8'h00; in7 = 8'h77; in8 = 8'h00;
            choose = 3'b110;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 8: Select in8 (choose=7)");
            in1 = 8'h00; in2 = 8'h00; in3 = 8'h00; in4 = 8'h00;
            in5 = 8'h00; in6 = 8'h00; in7 = 8'h00; in8 = 8'h88;
            choose = 3'b111;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 9: Verify sensitivity (change data on active select)");
            in1 = 8'hFF; in2 = 8'hEE; in3 = 8'hDD; in4 = 8'hCC;
            in5 = 8'hBB; in6 = 8'hAA; in7 = 8'h99; in8 = 8'h88;
            choose = 3'b011;
            #5;
            in4 = 8'h33;
            #1;

            check_outputs(8'h33);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
