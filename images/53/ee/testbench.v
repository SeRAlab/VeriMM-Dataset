`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg e;
    reg w;
    reg x;
    reg y;
    reg z;
    wire [15:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .w(w),
        .x(x),
        .y(y),
        .z(z),
        .d(d)
    );
    task testcase001;

    begin
        test_num = 1;
        e = 0; x = 0; y = 0; z = 0; w = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        e = 0; x = 1; y = 1; z = 1; w = 1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        e = 1; x = 0; y = 0; z = 0; w = 0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        e = 1; x = 0; y = 0; z = 0; w = 1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        e = 1; x = 0; y = 0; z = 1; w = 0;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        e = 1; x = 0; y = 0; z = 1; w = 1;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        e = 1; x = 0; y = 1; z = 0; w = 0;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        e = 1; x = 0; y = 1; z = 0; w = 1;
        #1;

        check_outputs(16'h0020);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        e = 1; x = 0; y = 1; z = 1; w = 0;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        e = 1; x = 0; y = 1; z = 1; w = 1;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        e = 1; x = 1; y = 0; z = 0; w = 0;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        e = 1; x = 1; y = 0; z = 0; w = 1;
        #1;

        check_outputs(16'h0200);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        e = 1; x = 1; y = 0; z = 1; w = 0;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        e = 1; x = 1; y = 0; z = 1; w = 1;
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        e = 1; x = 1; y = 1; z = 0; w = 0;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        e = 1; x = 1; y = 1; z = 0; w = 1;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        e = 1; x = 1; y = 1; z = 1; w = 0;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase018;

    begin
        test_num = 18;
        e = 1; x = 1; y = 1; z = 1; w = 1;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase019;

    begin
        test_num = 19;
        e = 0; x = 1; y = 0; z = 1; w = 0;
        #1;

        check_outputs(16'h0000);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        testcase019();
        
        
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
        input [15:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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
