`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] s;
    wire [22:0] out_and3;
    wire [22:0] out_nor3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .out_and3(out_and3),
        .out_nor3(out_nor3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            s = 24'h000000;

            #1;


            check_outputs(23'h000000, 23'h7FFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            s = 24'hFFFFFF;

            #1;


            check_outputs(23'h7FFFFF, 23'h000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            s = 24'hAAAAAA;

            #1;


            check_outputs(23'h000000, 23'h000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            s = 24'h555555;

            #1;


            check_outputs(23'h000000, 23'h000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            s = 24'hF0F0F0;


            #1;



            check_outputs(23'h707070, 23'h070707);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            s = 24'h123456;


            #1;



            check_outputs(23'h001002, 23'h64C180);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            s = 24'h000001;

            #1;


            check_outputs(23'h000000, 23'h7FFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            s = 24'h800000;

            #1;


            check_outputs(23'h000000, 23'h3FFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            s = 24'h000003;


            #1;



            check_outputs(23'h000001, 23'h7FFFFC);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            s = 24'hC00000;


            #1;



            check_outputs(23'h400000, 23'h1FFFFF);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            s = 24'h6DB6DB;


            #1;



            check_outputs(23'h249249, 23'h000000);
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
        testcase011();
        
        
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
        input [22:0] expected_out_and3;
        input [22:0] expected_out_nor3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and3 === (expected_out_and3 ^ out_and3 ^ expected_out_and3) &&
                expected_out_nor3 === (expected_out_nor3 ^ out_nor3 ^ expected_out_nor3)) begin
                $display("PASS");
                $display("  Outputs: out_and3=%h, out_nor3=%h",
                         out_and3, out_nor3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and3=%h, out_nor3=%h",
                         expected_out_and3, expected_out_nor3);
                $display("  Got:      out_and3=%h, out_nor3=%h",
                         out_and3, out_nor3);
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
