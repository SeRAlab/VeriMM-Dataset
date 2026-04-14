`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg ldsrc;
    reg shiftnld;
    wire crcerror;
    wire cyclecomplete;
    wire regout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ldsrc(ldsrc),
        .shiftnld(shiftnld),
        .crcerror(crcerror),
        .cyclecomplete(cyclecomplete),
        .regout(regout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase%03d: Initial Load Source 0", test_num);

        shiftnld = 0;
        ldsrc = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase%03d: Initial Load Source 1", test_num);

        shiftnld = 0;
        ldsrc = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase%03d: Transition to Shift Mode", test_num);

        shiftnld = 0;
        ldsrc = 0;
        @(posedge clk);

        shiftnld = 1;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase%03d: Complete CRC Cycle", test_num);

        shiftnld = 0;
        ldsrc = 0;
        @(posedge clk);

        shiftnld = 1;
        repeat(32) @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase%03d: Interrupted Shift and Reload", test_num);

        shiftnld = 0;
        ldsrc = 0;
        @(posedge clk);

        shiftnld = 1;
        repeat(5) @(posedge clk);

        shiftnld = 0;
        ldsrc = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_cyclecomplete;
        input expected_regout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crcerror === (expected_crcerror ^ crcerror ^ expected_crcerror) &&
                expected_cyclecomplete === (expected_cyclecomplete ^ cyclecomplete ^ expected_cyclecomplete) &&
                expected_regout === (expected_regout ^ regout ^ expected_regout)) begin
                $display("PASS");
                $display("  Outputs: crcerror=%b, cyclecomplete=%b, regout=%b",
                         crcerror, cyclecomplete, regout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crcerror=%b, cyclecomplete=%b, regout=%b",
                         expected_crcerror, expected_cyclecomplete, expected_regout);
                $display("  Got:      crcerror=%b, cyclecomplete=%b, regout=%b",
                         crcerror, cyclecomplete, regout);
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
