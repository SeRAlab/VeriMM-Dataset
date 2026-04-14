`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Selm;
    reg [7:0] V;
    reg [7:0] W;
    wire [7:0] F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Selm(Selm),
        .V(V),
        .W(W),
        .F(F)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Selm=0, selecting V", test_num);
            V = 8'h12;
            W = 8'h34;
            Selm = 1'b0;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Selm=1, selecting W", test_num);
            V = 8'h12;
            W = 8'h34;
            Selm = 1'b1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Selm=0, V is all ones", test_num);
            V = 8'hFF;
            W = 8'h00;
            Selm = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Selm=1, W is all zeros", test_num);
            V = 8'hFF;
            W = 8'h00;
            Selm = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Selm=0, alternating bit pattern V", test_num);
            V = 8'h55;
            W = 8'hAA;
            Selm = 1'b0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Selm=1, alternating bit pattern W", test_num);
            V = 8'h55;
            W = 8'hAA;
            Selm = 1'b1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Selm=0, random values", test_num);
            V = 8'hA5;
            W = 8'h5A;
            Selm = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Selm=1, random values", test_num);
            V = 8'hA5;
            W = 8'h5A;
            Selm = 1'b1;
            #1;

            check_outputs(8'h5A);
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
        input [7:0] expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%h",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%h",
                         expected_F);
                $display("  Got:      F=%h",
                         F);
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
