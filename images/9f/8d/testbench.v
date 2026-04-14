`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [3:0] gin;
    reg [3:0] pin;
    wire [2:0] cout;
    wire gout;
    wire pout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .gin(gin),
        .pin(pin),
        .cout(cout),
        .gout(gout),
        .pout(pout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            gin = 4'b0000;
            pin = 4'b0000;
            cin = 1'b0;
            #1;

            check_outputs(3'b000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Propagate with Carry-in", test_num);
            gin = 4'b0000;
            pin = 4'b1111;
            cin = 1'b1;


            #1;



            check_outputs(3'b111, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Generate from LSB", test_num);
            gin = 4'b0001;
            pin = 4'b1110;
            cin = 1'b0;





            #1;






            check_outputs(3'b111, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Generate from MSB only", test_num);
            gin = 4'b1000;
            pin = 4'b0000;
            cin = 1'b0;


            #1;



            check_outputs(3'b000, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Propagate chain broken", test_num);
            gin = 4'b0000;
            pin = 4'b1011;
            cin = 1'b1;




            #1;





            check_outputs(3'b011, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Generate and Propagate", test_num);
            gin = 4'b0100;
            pin = 4'b1011;
            cin = 1'b0;





            #1;






            check_outputs(3'b100, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Generate and All Propagate", test_num);
            gin = 4'b1111;
            pin = 4'b1111;
            cin = 1'b1;

            #1;


            check_outputs(3'b111, 1'b1, 1'b1);
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
        input [2:0] expected_cout;
        input expected_gout;
        input expected_pout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_gout === (expected_gout ^ gout ^ expected_gout) &&
                expected_pout === (expected_pout ^ pout ^ expected_pout)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, gout=%b, pout=%b",
                         cout, gout, pout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, gout=%b, pout=%b",
                         expected_cout, expected_gout, expected_pout);
                $display("  Got:      cout=%h, gout=%b, pout=%b",
                         cout, gout, pout);
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
