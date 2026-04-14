`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [90:0] wrap64_setValidCap_cap;
    reg wrap64_setValidCap_valid;
    wire [90:0] wrap64_setValidCap;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wrap64_setValidCap_cap(wrap64_setValidCap_cap),
        .wrap64_setValidCap_valid(wrap64_setValidCap_valid),
        .wrap64_setValidCap(wrap64_setValidCap)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: valid=1, cap=all 0s", test_num);
        wrap64_setValidCap_valid = 1'b1;
        wrap64_setValidCap_cap = 91'h0;

        #1;


        check_outputs(91'h40000000000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: valid=0, cap=all 1s (90 bits)", test_num);
        wrap64_setValidCap_valid = 1'b0;
        wrap64_setValidCap_cap = 91'h3FFFFFFFFFFFFFFFFFFFFFF;

        #1;


        check_outputs(91'h3FFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: valid=1, cap=all 1s (90 bits)", test_num);
        wrap64_setValidCap_valid = 1'b1;
        wrap64_setValidCap_cap = 91'h3FFFFFFFFFFFFFFFFFFFFFF;

        #1;


        check_outputs(91'h7FFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: valid=0, cap with alternating pattern A", test_num);
        wrap64_setValidCap_valid = 1'b0;
        wrap64_setValidCap_cap = 91'h2AAAAAAAAAAAAAAAAAAAAAA;


        #1;



        check_outputs(91'h2AAAAAAAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: valid=1, cap with alternating pattern 5", test_num);
        wrap64_setValidCap_valid = 1'b1;
        wrap64_setValidCap_cap = 91'h15555555555555555555555;


        #1;



        check_outputs(91'h55555555555555555555555);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input cap bit 90 is ignored", test_num);
        wrap64_setValidCap_valid = 1'b0;
        wrap64_setValidCap_cap = 91'h40000000000000000000000;

        #1;


        check_outputs(91'h00000000000000000000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern check", test_num);
        wrap64_setValidCap_valid = 1'b1;
        wrap64_setValidCap_cap = 91'h123456789ABCDEF01234567;


        #1;



        check_outputs(91'h523456789ABCDEF01234567);
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
        input [90:0] expected_wrap64_setValidCap;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wrap64_setValidCap === (expected_wrap64_setValidCap ^ wrap64_setValidCap ^ expected_wrap64_setValidCap)) begin
                $display("PASS");
                $display("  Outputs: wrap64_setValidCap=%h",
                         wrap64_setValidCap);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wrap64_setValidCap=%h",
                         expected_wrap64_setValidCap);
                $display("  Got:      wrap64_setValidCap=%h",
                         wrap64_setValidCap);
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
