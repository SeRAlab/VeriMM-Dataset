`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    wire [1:0] cout;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            x = 32'h0;
            #10;
            x = 32'h0000_0000;
            $display("Test %0d: All Zeros (0x0000 + 0x0000)", test_num);
            #1;

            check_outputs(2'b00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            x = 32'h0;
            #10;
            x = 32'h0002_0003;
            $display("Test %0d: Small values, no carries", test_num);
            #1;

            check_outputs(2'b00, 8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            x = 32'h0;
            #10;


            x = 32'h0001_00FF;
            $display("Test %0d: Internal carry (cout[0])", test_num);
            #1;

            check_outputs(2'b01, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            x = 32'h0;
            #10;


            x = 32'h8000_8000;
            $display("Test %0d: Final carry-out (cout[1])", test_num);
            #1;

            check_outputs(2'b10, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            x = 32'h0;
            #10;



            x = 32'h80FF_8001;
            $display("Test %0d: Both carries (cout=2'b11)", test_num);
            #1;

            check_outputs(2'b11, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            x = 32'h0;
            #10;

            x = 32'h1234_4321;
            $display("Test %0d: Large values, mixed bits", test_num);
            #1;

            check_outputs(2'b00, 8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            x = 32'h0;
            #10;


            x = 32'hFFFF_FFFF;
            $display("Test %0d: Maximum input values", test_num);
            #1;

            check_outputs(2'b11, 8'hFE);
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
        input [1:0] expected_cout;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%h, sum=%h",
                         cout, sum);
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
