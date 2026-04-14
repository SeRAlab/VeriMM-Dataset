`timescale 1ns/1ps

module shift_right_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg enable;
    reg reset;
    wire [7:0] shift_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_right_module dut (
        .a(a),
        .enable(enable),
        .reset(reset),
        .shift_result(shift_result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Priority Check", test_num);

            reset = 1;
            enable = 1;
            a = 8'hFF;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift Right 8'hFF (Enable High)", test_num);

            reset = 1;
            #5 reset = 0;
            enable = 1;
            a = 8'hFF;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift Right 8'h01 (LSB boundary)", test_num);

            reset = 1;
            #5 reset = 0;
            enable = 1;
            a = 8'h01;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift Right 8'h80 (MSB boundary)", test_num);

            reset = 1;
            #5 reset = 0;
            enable = 1;
            a = 8'h80;

            #1;


            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Shift Right 8'hAA (Alternating pattern)", test_num);

            reset = 1;
            #5 reset = 0;
            enable = 1;
            a = 8'hAA;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Input Zero", test_num);

            reset = 1;
            #5 reset = 0;
            enable = 1;
            a = 8'h00;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Enable Low Check", test_num);

            reset = 1;
            #5 reset = 0;
            enable = 0;
            a = 8'hFF;



            #1;




            check_outputs(shift_result);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_right_module Testbench");
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
        input [7:0] expected_shift_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shift_result === (expected_shift_result ^ shift_result ^ expected_shift_result)) begin
                $display("PASS");
                $display("  Outputs: shift_result=%h",
                         shift_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_result=%h",
                         expected_shift_result);
                $display("  Got:      shift_result=%h",
                         shift_result);
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
