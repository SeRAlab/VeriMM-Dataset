`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [21:0] q;
    wire [20:0] out_or3;
    wire [20:0] out_xor3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .q(q),
        .out_or3(out_or3),
        .out_xor3(out_xor3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        q = 22'h0;
        #1;

        check_outputs(21'h0, 21'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones", test_num);
        q = 22'h3FFFFF;
        #1;

        check_outputs(21'h1FFFFF, 21'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern 0101...", test_num);
        q = 22'h155555;


        #1;



        check_outputs(21'h1FFFFF, 21'h1FFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern 1010...", test_num);
        q = 22'h2AAAAA;
        #1;

        check_outputs(21'h1FFFFF, 21'h1FFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit at q[0]", test_num);
        q = 22'h000001;

        #1;


        check_outputs(21'h000001, 21'h000001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit at q[21]", test_num);
        q = 22'h200000;

        #1;


        check_outputs(21'h100000, 21'h100000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Neighboring bits q[0] and q[1] both 1", test_num);
        q = 22'h000003;


        #1;



        check_outputs(21'h000003, 21'h000002);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arbitrary pattern 123456", test_num);
        q = 22'h123456;





        #1;






        check_outputs(21'h1B3E7F, 21'h1B2E7D);
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
        input [20:0] expected_out_or3;
        input [20:0] expected_out_xor3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_or3 === (expected_out_or3 ^ out_or3 ^ expected_out_or3) &&
                expected_out_xor3 === (expected_out_xor3 ^ out_xor3 ^ expected_out_xor3)) begin
                $display("PASS");
                $display("  Outputs: out_or3=%h, out_xor3=%h",
                         out_or3, out_xor3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or3=%h, out_xor3=%h",
                         expected_out_or3, expected_out_xor3);
                $display("  Got:      out_or3=%h, out_xor3=%h",
                         out_or3, out_xor3);
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
