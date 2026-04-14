`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in1;
    reg [8:0] in2;
    wire [9:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .res(res)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 9'h000; in2 = 9'h000;


            #1;



            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 9'h005; in2 = 9'h00A;



            #1;




            check_outputs(10'h00F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 9'h01F; in2 = 9'h001;



            #1;




            check_outputs(10'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 9'h010; in2 = 9'h010;



            #1;




            check_outputs(10'h020);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 9'h1F0; in2 = 9'h1F0;



            #1;




            check_outputs(10'h3E0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in1 = 9'h1FF; in2 = 9'h1FF;



            #1;




            check_outputs(10'h3FE);
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
        input [9:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
