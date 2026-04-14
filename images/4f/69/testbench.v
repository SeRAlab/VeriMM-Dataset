`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] B;
    wire [23:0] SEL_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .SEL_out(SEL_out)
    );
    task init;

        begin
            B = 0;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            B = 16'h0000;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            B = 16'hFFFF;



            #1;




            check_outputs(24'hFFFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            B = 16'hAAAA;










            #1;











            check_outputs(24'hB6DB60);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            B = 16'h5555;











            #1;












            check_outputs(24'h49249E);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            B = 16'h0001;


            #1;



            check_outputs(24'h000002);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            B = 16'h8000;


            #1;



            check_outputs(24'h800000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            B = 16'h1234;



            #1;




            check_outputs(24'h04145C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            B = 16'hC3C3;



            #1;




            check_outputs(24'hC7178E);
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
        input [23:0] expected_SEL_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SEL_out === (expected_SEL_out ^ SEL_out ^ expected_SEL_out)) begin
                $display("PASS");
                $display("  Outputs: SEL_out=%h",
                         SEL_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SEL_out=%h",
                         expected_SEL_out);
                $display("  Got:      SEL_out=%h",
                         SEL_out);
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
