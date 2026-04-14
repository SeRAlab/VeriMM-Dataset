`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] fio;
    reg luz;
    wire cont1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fio(fio),
        .luz(luz),
        .cont1(cont1)
    );
    task testcase001;

        begin
            test_num = 1;
            fio = 6'b000000;
            luz = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            fio = 6'b000001;
            luz = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            fio = 6'b100000;
            luz = 1'b1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            fio = 6'b111111;
            luz = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            fio = 6'b010101;
            luz = 1'b1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            fio = 6'b101010;
            luz = 1'b1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            fio = 6'b110011;
            luz = 1'b0;

            #1;


            check_outputs(1'b1);
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
        input expected_cont1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cont1 === (expected_cont1 ^ cont1 ^ expected_cont1)) begin
                $display("PASS");
                $display("  Outputs: cont1=%b",
                         cont1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cont1=%b",
                         expected_cont1);
                $display("  Got:      cont1=%b",
                         cont1);
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
