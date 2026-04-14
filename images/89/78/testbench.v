`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Data_A;
    reg [7:0] Data_B;
    reg op_mode;
    wire [8:0] Data_S;
    wire n3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_A(Data_A),
        .Data_B(Data_B),
        .op_mode(op_mode),
        .Data_S(Data_S),
        .n3(n3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            op_mode = 0;
            Data_A = 8'd10;
            Data_B = 8'd20;
            $display("Test Case %0d: Addition 10 + 20", test_num);
            #1;

            check_outputs(9'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            op_mode = 0;
            Data_A = 8'hFF;
            Data_B = 8'h01;
            $display("Test Case %0d: Addition 255 + 1 (Carry Out)", test_num);
            #1;

            check_outputs(9'h100, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            op_mode = 0;
            Data_A = 8'hFF;
            Data_B = 8'hFF;
            $display("Test Case %0d: Addition 255 + 255", test_num);
            #1;

            check_outputs(9'h1FE, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            op_mode = 1;
            Data_A = 8'd50;
            Data_B = 8'd20;
            $display("Test Case %0d: Subtraction 50 - 20", test_num);
            #1;

            check_outputs(9'd30, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            op_mode = 1;
            Data_A = 8'd100;
            Data_B = 8'd100;
            $display("Test Case %0d: Subtraction 100 - 100", test_num);
            #1;

            check_outputs(9'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            op_mode = 1;
            Data_A = 8'd10;
            Data_B = 8'd20;
            $display("Test Case %0d: Subtraction 10 - 20 (Negative result)", test_num);

            #1;


            check_outputs(9'h1F6, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            op_mode = 0;
            Data_A = 8'd0;
            Data_B = 8'd0;
            $display("Test Case %0d: Addition 0 + 0", test_num);
            #1;

            check_outputs(9'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            op_mode = 1;
            Data_A = 8'hFF;
            Data_B = 8'h00;
            $display("Test Case %0d: Subtraction 255 - 0", test_num);
            #1;

            check_outputs(9'h0FF, 1'b1);
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
        input [8:0] expected_Data_S;
        input expected_n3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Data_S === (expected_Data_S ^ Data_S ^ expected_Data_S) &&
                expected_n3 === (expected_n3 ^ n3 ^ expected_n3)) begin
                $display("PASS");
                $display("  Outputs: Data_S=%h, n3=%b",
                         Data_S, n3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_S=%h, n3=%b",
                         expected_Data_S, expected_n3);
                $display("  Got:      Data_S=%h, n3=%b",
                         Data_S, n3);
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
