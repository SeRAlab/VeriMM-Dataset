`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .s(s)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All zeros", test_num);
            a = 64'h0;
            b = 64'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple small addition", test_num);
            a = 64'h0000_0000_0000_0005;
            b = 64'h0000_0000_0000_000A;
            #1;

            check_outputs(64'h0000_0000_0000_000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Max value plus zero", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h0000_0000_0000_0000;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Maximum value overflow (wrap around)", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Carry propagation across middle", test_num);
            a = 64'h0000_0000_FFFF_FFFF;
            b = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(64'h0000_0001_0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            a = 64'hAAAA_AAAA_AAAA_AAAA;
            b = 64'h5555_5555_5555_5555;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Large value addition", test_num);
            a = 64'h1234_5678_9ABC_DEF0;
            b = 64'h1111_1111_1111_1111;
            #1;

            check_outputs(64'h2345_6789_ABCE_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Max value plus max value", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'hFFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Single bit high in middle", test_num);
            a = 64'h0000_0000_8000_0000;
            b = 64'h0000_0000_8000_0000;
            #1;

            check_outputs(64'h0000_0001_0000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Random pattern test", test_num);
            a = 64'hDEAD_BEEF_CAFE_BABE;
            b = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(64'hDEAD_BEEF_CAFE_BABF);
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
        input [63:0] expected_s;
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
