`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg sel;
    wire outA;
    wire outB;
    wire outC;
    wire outD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .sel(sel),
        .outA(outA),
        .outB(outB),
        .outC(outC),
        .outD(outD)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Resetting DUT...", test_num);
        in = 0;
        sel = 2'b00;
        @(posedge clk);
        sel = 2'b01;
        @(posedge clk);
        sel = 2'b10;
        @(posedge clk);
        sel = 2'b11;
        @(posedge clk);
        in = 0;
        sel = 2'b00;
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Routing in=1 to outA (sel=00)");
        in = 1;
        sel = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Routing in=1 to outB (sel=01)");
        in = 1;
        sel = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Routing in=1 to outC (sel=10)");
        in = 1;
        sel = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Routing in=1 to outD (sel=11)");
        in = 1;
        sel = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testing persistence: Set outA=1, then set outC=1");


        in = 1;
        sel = 2'b00;
        @(posedge clk);


        in = 1;
        sel = 2'b10;
        @(posedge clk);

        #1;
        #1;

        check_outputs(1, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testing sequence: outD=1, then outB=1, then outD=0");


        in = 1; sel = 2'b11; @(posedge clk);

        in = 1; sel = 2'b01; @(posedge clk);

        in = 0; sel = 2'b11; @(posedge clk);

        #1;

        #1;


        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testing toggle: outA=1, then outA=0");

        in = 1; sel = 2'b00; @(posedge clk);
        in = 0; sel = 2'b00; @(posedge clk);

        #1;
        #1;

        check_outputs(0, 0, 0, 0);
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
        input expected_outA;
        input expected_outB;
        input expected_outC;
        input expected_outD;
        begin
            if (expected_outA === (expected_outA ^ outA ^ expected_outA) &&
                expected_outB === (expected_outB ^ outB ^ expected_outB) &&
                expected_outC === (expected_outC ^ outC ^ expected_outC) &&
                expected_outD === (expected_outD ^ outD ^ expected_outD)) begin
                $display("PASS");
                $display("  Outputs: outA=%b, outB=%b, outC=%b, outD=%b",
                         outA, outB, outC, outD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outA=%b, outB=%b, outC=%b, outD=%b",
                         expected_outA, expected_outB, expected_outC, expected_outD);
                $display("  Got:      outA=%b, outB=%b, outC=%b, outD=%b",
                         outA, outB, outC, outD);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, in, sel, outA, outB, outC, outD);
    end

endmodule
