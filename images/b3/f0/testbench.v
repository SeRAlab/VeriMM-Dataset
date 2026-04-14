`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg vz;
    reg [7:0] z;
    wire [7:0] d;
    wire vd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vz(vz),
        .z(z),
        .d(d),
        .vd(vd)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros, valid high", test_num);
            vz = 1'b1;
            z = 8'h00;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones, valid high", test_num);
            vz = 1'b1;
            z = 8'hFF;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (AA), valid high", test_num);
            vz = 1'b1;
            z = 8'hAA;
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (55), valid high", test_num);
            vz = 1'b1;
            z = 8'h55;
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data check with valid low", test_num);
            vz = 1'b0;
            z = 8'hA5;
            #1;

            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary value 01, valid high", test_num);
            vz = 1'b1;
            z = 8'h01;
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary value FE, valid high", test_num);
            vz = 1'b1;
            z = 8'hFE;
            #1;

            check_outputs(8'hFE, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern, valid low", test_num);
            vz = 1'b0;
            z = 8'h12;
            #1;

            check_outputs(8'h12, 1'b0);
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
        input [7:0] expected_d;
        input expected_vd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d) &&
                expected_vd === (expected_vd ^ vd ^ expected_vd)) begin
                $display("PASS");
                $display("  Outputs: d=%h, vd=%b",
                         d, vd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h, vd=%b",
                         expected_d, expected_vd);
                $display("  Got:      d=%h, vd=%b",
                         d, vd);
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
