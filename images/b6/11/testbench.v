`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg shiftnld;
    wire crcerror;
    wire regout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .shiftnld(shiftnld),
        .crcerror(crcerror),
        .regout(regout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset/Load State", test_num);

            shiftnld = 0;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Short Shift Sequence", test_num);


            shiftnld = 0;
            @(posedge clk);


            shiftnld = 1;
            repeat(4) @(posedge clk);


            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Byte-length Shift Sequence", test_num);

            shiftnld = 0;
            @(posedge clk);

            shiftnld = 1;
            repeat(8) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mode Toggle (Shift-Load-Shift)", test_num);

            shiftnld = 0;
            @(posedge clk);

            shiftnld = 1;
            repeat(5) @(posedge clk);

            shiftnld = 0;
            @(posedge clk);

            shiftnld = 1;
            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Extended Operation", test_num);

            shiftnld = 0;
            @(posedge clk);

            shiftnld = 1;
            repeat(32) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_crcerror;
        input expected_regout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crcerror === (expected_crcerror ^ crcerror ^ expected_crcerror) &&
                expected_regout === (expected_regout ^ regout ^ expected_regout)) begin
                $display("PASS");
                $display("  Outputs: crcerror=%b, regout=%b",
                         crcerror, regout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crcerror=%b, regout=%b",
                         expected_crcerror, expected_regout);
                $display("  Got:      crcerror=%b, regout=%b",
                         crcerror, regout);
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
