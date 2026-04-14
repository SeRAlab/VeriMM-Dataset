`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] p;
    reg [3:0] q;
    reg [1:0] r;
    wire [3:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .q(q),
        .r(r),
        .s(s)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=0 (s should be 1)", test_num);
        p = 4'hA; q = 4'h5; r = 2'b00;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=0 with different inputs", test_num);
        p = 4'hF; q = 4'hF; r = 2'b00;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=1 (s should be q)", test_num);
        p = 4'hA; q = 4'h5; r = 2'b01;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=1 (s should be q)", test_num);
        p = 4'h0; q = 4'hE; r = 2'b01;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=2 (s should be p)", test_num);
        p = 4'hA; q = 4'h5; r = 2'b10;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=2 (s should be p)", test_num);
        p = 4'h3; q = 4'h0; r = 2'b10;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=3 (s should be p | q)", test_num);
        p = 4'hA; q = 4'h5; r = 2'b11;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=3 (s should be p | q)", test_num);
        p = 4'h8; q = 4'h1; r = 2'b11;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=3 with overlapping bits", test_num);
        p = 4'b1100; q = 4'b1010; r = 2'b11;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: r=1 with q=0", test_num);
        p = 4'hF; q = 4'h0; r = 2'b01;
        #1;

        check_outputs(4'h0);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
