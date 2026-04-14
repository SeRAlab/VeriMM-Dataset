`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg select;
    wire [7:0] out_and;
    wire [7:0] out_not;
    wire [7:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .select(select),
        .out_and(out_and),
        .out_not(out_not),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: select=0, a=55, b=AA", test_num);
            a = 8'h55;
            b = 8'hAA;
            select = 1'b0;


            #1;



            check_outputs(8'h00, 8'h55, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: select=1, a=55, b=AA", test_num);
            a = 8'h55;
            b = 8'hAA;
            select = 1'b1;


            #1;



            check_outputs(8'hFF, 8'h55, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All zeros, select=0", test_num);
            a = 8'h00;
            b = 8'h00;
            select = 1'b0;

            #1;


            check_outputs(8'h00, 8'hFF, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All ones, select=1", test_num);
            a = 8'hFF;
            b = 8'hFF;
            select = 1'b1;


            #1;



            check_outputs(8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Mixed pattern, select=0", test_num);
            a = 8'h12;
            b = 8'h34;
            select = 1'b0;



            #1;




            check_outputs(8'h10, 8'hCB, 8'h26);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Mixed pattern, select=1", test_num);
            a = 8'h12;
            b = 8'h34;
            select = 1'b1;

            #1;


            check_outputs(8'h26, 8'hCB, 8'h10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Change A, verify NOT remains same", test_num);
            a = 8'hFF;
            b = 8'hA5;
            select = 1'b0;

            #1;


            check_outputs(8'hA5, 8'h5A, 8'h5A);
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
        input [7:0] expected_out_and;
        input [7:0] expected_out_not;
        input [7:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_not=%h, out_xor=%h",
                         out_and, out_not, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_not=%h, out_xor=%h",
                         expected_out_and, expected_out_not, expected_out_xor);
                $display("  Got:      out_and=%h, out_not=%h, out_xor=%h",
                         out_and, out_not, out_xor);
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
