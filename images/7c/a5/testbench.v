`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] l;
    reg [31:0] r;
    wire [63:0] ct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .l(l),
        .r(r),
        .ct(ct)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase 001: All zeros");
            l = 32'h00000000;
            r = 32'h00000000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase 002: All ones");
            l = 32'hFFFFFFFF;
            r = 32'hFFFFFFFF;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase 003: Alternating bits (A/5)");
            l = 32'hAAAAAAAA;
            r = 32'h55555555;
            #1;

            check_outputs(64'hAAAAAAAA55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase 004: Left word high-bits, right word zero");
            l = 32'h12345678;
            r = 32'h00000000;
            #1;

            check_outputs(64'h1234567800000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase 005: Left word zero, right word high-bits");
            l = 32'h00000000;
            r = 32'h9ABCDEF0;
            #1;

            check_outputs(64'h000000009ABCDEF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase 006: Boundary bits check (MSB and LSB)");
            l = 32'h80000000;
            r = 32'h00000001;
            #1;

            check_outputs(64'h8000000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase 007: Hex pattern DEADBEEF CAFEBABE");
            l = 32'hDEADBEEF;
            r = 32'hCAFEBABE;
            #1;

            check_outputs(64'hDEADBEEFCAFEBABE);
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
        input [63:0] expected_ct;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ct === (expected_ct ^ ct ^ expected_ct)) begin
                $display("PASS");
                $display("  Outputs: ct=%h",
                         ct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ct=%h",
                         expected_ct);
                $display("  Got:      ct=%h",
                         ct);
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
