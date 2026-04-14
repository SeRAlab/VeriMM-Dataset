`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din0;
    reg din1;
    reg din2;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic positive multiplication and addition", test_num);
            din0 = 32'd5;
            din1 = 32'd10;
            din2 = 32'd20;

            #1;


            check_outputs(32'd70);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiplication by zero", test_num);
            din0 = 32'd0;
            din1 = 32'd100;
            din2 = 32'd50;

            #1;


            check_outputs(32'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Identity multiplication", test_num);
            din0 = 32'd1;
            din1 = 32'd1234;
            din2 = 32'd5678;

            #1;


            check_outputs(32'd6912);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Truncation of large product", test_num);

            din0 = 32'h00010000;
            din1 = 32'h00010000;
            din2 = 32'd15;



            #1;




            check_outputs(32'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative number handling", test_num);
            din0 = 32'hFFFFFFFF;
            din1 = 32'd5;
            din2 = 32'd10;

            #1;


            check_outputs(32'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max input values", test_num);
            din0 = 32'hFFFFFFFF;
            din1 = 32'h00000001;
            din2 = 32'hFFFFFFFF;

            #1;


            check_outputs(32'hFFFFFFFE);
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
        input expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
