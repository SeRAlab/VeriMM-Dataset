`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_1;
    reg [3:0] input_2;
    reg [7:0] input_3;
    reg [15:0] input_4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_2(input_2),
        .input_3(input_3),
        .input_4(input_4)
    );
    task testcase001;

        begin
            test_num = 1;
            input_1 = 1'b0;
            input_2 = 4'b1010;
            input_3 = 8'd130;
            input_4 = 16'hABCD;

            exp_out_1 = ~4'b1010;
            exp_out_2 = 16'h00CD;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input_1 = 1'b1;
            input_2 = 4'b0011;
            input_3 = 8'd50;
            input_4 = 16'h1234;

            exp_out_1 = 4'b1100;
            exp_out_2 = 16'hFF34;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input_1 = 1'b1;
            input_2 = 4'b1111;
            input_3 = 8'd128;
            input_4 = 16'hAAAA;

            exp_out_1 = 4'b1100;
            exp_out_2 = 16'h00AA;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input_1 = 1'b0;
            input_2 = 4'b0000;
            input_3 = 8'd0;
            input_4 = 16'h5555;

            exp_out_1 = 4'b1111;
            exp_out_2 = 16'hFF55;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input_1 = 1'b0;
            input_2 = 4'h7;
            input_3 = 8'hFF;
            input_4 = 16'h0000;

            exp_out_1 = 4'b1000;
            exp_out_2 = 16'h0000;
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
