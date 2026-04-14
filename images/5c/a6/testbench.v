`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [31:0] devRevision;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .devRevision(devRevision)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verifying Full Revision ID", test_num);
            $display("Specification: [31:24] Year, [23:16] Month, [15:8] Day, [7:0] Build");




            #1;





            check_outputs(32'h16050208);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Stability and Definition Check", test_num);


            if (^devRevision === 1'bX || ^devRevision === 1'bZ) begin
                $display("FAIL: devRevision contains invalid bits (X or Z)");
                fail_count = fail_count + 1;
            end else begin

                #50;
                #1;

                check_outputs(32'h16050208);
            end
        end
        endtask

    task testcase003;

        reg [7:0] year;
        reg [7:0] build;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Field Boundary Check", test_num);

            year = devRevision[31:24];
            build = devRevision[7:0];

            if (year == 8'h16 && build == 8'h08) begin
                $display("PASS: Year (MSB) and Build (LSB) positions are correct.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Incorrect field mapping. Year=%h, Build=%h", year, build);
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_devRevision;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_devRevision === (expected_devRevision ^ devRevision ^ expected_devRevision)) begin
                $display("PASS");
                $display("  Outputs: devRevision=%h",
                         devRevision);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: devRevision=%h",
                         expected_devRevision);
                $display("  Got:      devRevision=%h",
                         devRevision);
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
