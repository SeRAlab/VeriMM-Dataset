`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg [1:0] g;
    reg [1:0] p;
    wire [1:0] c;
    wire gout;
    wire pout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cin(Cin),
        .g(g),
        .p(p),
        .c(c),
        .gout(gout),
        .pout(pout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            Cin = 1'b0;
            g = 2'b00;
            p = 2'b00;

            #1;


            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Propagate Cin to c[0]", test_num);
            Cin = 1'b1;
            g = 2'b00;
            p = 2'b01;




            #1;





            check_outputs(2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Propagate Cin to c[1] (Full Propagate)", test_num);
            Cin = 1'b1;
            g = 2'b00;
            p = 2'b11;


            #1;



            check_outputs(2'b11, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Generate carry from bit 0", test_num);
            Cin = 1'b0;
            g = 2'b01;
            p = 2'b00;


            #1;



            check_outputs(2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Generate carry from bit 1", test_num);
            Cin = 1'b0;
            g = 2'b10;
            p = 2'b00;


            #1;



            check_outputs(2'b10, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 0 generate propagates to bit 1", test_num);
            Cin = 1'b0;
            g = 2'b01;
            p = 2'b10;



            #1;




            check_outputs(2'b11, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex mix - Cin propagates and g[1] generates", test_num);
            Cin = 1'b1;
            g = 2'b10;
            p = 2'b01;




            #1;





            check_outputs(2'b11, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values", test_num);
            Cin = 1'b1;
            g = 2'b11;
            p = 2'b11;

            #1;


            check_outputs(2'b11, 1'b1, 1'b1);
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
        input [1:0] expected_c;
        input expected_gout;
        input expected_pout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_gout === (expected_gout ^ gout ^ expected_gout) &&
                expected_pout === (expected_pout ^ pout ^ expected_pout)) begin
                $display("PASS");
                $display("  Outputs: c=%h, gout=%b, pout=%b",
                         c, gout, pout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, gout=%b, pout=%b",
                         expected_c, expected_gout, expected_pout);
                $display("  Got:      c=%h, gout=%b, pout=%b",
                         c, gout, pout);
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
