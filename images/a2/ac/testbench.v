`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] vra;
    reg [31:0] vrb;
    wire [31:0] vrt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vra(vra),
        .vrb(vrb),
        .vrt(vrt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both halves match", test_num);
            vra = 32'h12345678;
            vrb = 32'h12345678;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only lower half matches", test_num);
            vra = 32'hAAAA5555;
            vrb = 32'hBBBB5555;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only upper half matches", test_num);
            vra = 32'hAAAA5555;
            vrb = 32'hAAAA6666;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Neither half matches", test_num);
            vra = 32'h11112222;
            vrb = 32'h33334444;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            vra = 32'h00000000;
            vrb = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            vra = 32'hFFFFFFFF;
            vrb = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit diff in lower half", test_num);
            vra = 32'h12340001;
            vrb = 32'h12340000;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit diff in upper half", test_num);
            vra = 32'h80001234;
            vrb = 32'h00001234;
            #1;

            check_outputs(32'h0000FFFF);
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
        input [31:0] expected_vrt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vrt === (expected_vrt ^ vrt ^ expected_vrt)) begin
                $display("PASS");
                $display("  Outputs: vrt=%h",
                         vrt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vrt=%h",
                         expected_vrt);
                $display("  Got:      vrt=%h",
                         vrt);
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
