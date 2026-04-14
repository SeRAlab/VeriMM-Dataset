`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg EN_get;
    reg EN_put;
    reg RST;
    reg put;
    wire RDY_get;
    wire RDY_put;
    wire get;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN_get(EN_get),
        .EN_put(EN_put),
        .RST(RST),
        .put(put),
        .RDY_get(RDY_get),
        .RDY_put(RDY_put),
        .get(get)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b1, 1'bx);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Put data 1", test_num);
        reset_dut();

        @(posedge CLK);
        EN_put = 1;
        put = 1;
        @(posedge CLK);
        EN_put = 0;


        #1;



        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Put data 0", test_num);
        reset_dut();

        @(posedge CLK);
        EN_put = 1;
        put = 0;
        @(posedge CLK);
        EN_put = 0;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Fill Buffer (Depth 2)", test_num);
        reset_dut();


        @(posedge CLK);
        EN_put = 1; put = 1;
        @(posedge CLK);

        EN_put = 1; put = 0;
        @(posedge CLK);
        EN_put = 0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Fill and Read Second Item", test_num);
        reset_dut();


        @(posedge CLK);
        EN_put = 1; put = 1;
        @(posedge CLK);
        EN_put = 1; put = 0;
        @(posedge CLK);
        EN_put = 0;


        EN_get = 1;
        @(posedge CLK);
        EN_get = 0;



        #1;




        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Emptying Buffer", test_num);
        reset_dut();


        @(posedge CLK);
        EN_put = 1; put = 1;
        @(posedge CLK);
        EN_put = 0;


        EN_get = 1;
        @(posedge CLK);
        EN_get = 0;


        #1;



        check_outputs(1'b0, 1'b1, 1'bx);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Simultaneous Put and Get", test_num);
        reset_dut();


        @(posedge CLK);
        EN_put = 1; put = 1;
        @(posedge CLK);


        EN_put = 1; put = 0;
        EN_get = 1;
        @(posedge CLK);
        EN_put = 0;
        EN_get = 0;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_RDY_get;
        input expected_RDY_put;
        input expected_get;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RDY_get === (expected_RDY_get ^ RDY_get ^ expected_RDY_get) &&
                expected_RDY_put === (expected_RDY_put ^ RDY_put ^ expected_RDY_put) &&
                expected_get === (expected_get ^ get ^ expected_get)) begin
                $display("PASS");
                $display("  Outputs: RDY_get=%b, RDY_put=%b, get=%b",
                         RDY_get, RDY_put, get);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RDY_get=%b, RDY_put=%b, get=%b",
                         expected_RDY_get, expected_RDY_put, expected_get);
                $display("  Got:      RDY_get=%b, RDY_put=%b, get=%b",
                         RDY_get, RDY_put, get);
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
