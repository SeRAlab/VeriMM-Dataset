`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr_in;
    wire [31:0] addr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in(addr_in),
        .addr_out(addr_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input equals offset", test_num);
            addr_in = 32'h10010000;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small positive result (aligned by 4)", test_num);
            addr_in = 32'h10010004;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Result with truncation", test_num);
            addr_in = 32'h1001000B;

            #1;


            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small negative result", test_num);
            addr_in = 32'h1000FFFC;


            #1;



            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Larger positive offset", test_num);
            addr_in = 32'h10010400;


            #1;



            check_outputs(32'h00000100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max input value", test_num);
            addr_in = 32'hFFFFFFFF;



            #1;




            check_outputs(32'hFBFBFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input is zero", test_num);
            addr_in = 32'h00000000;



            #1;




            check_outputs(32'hFBFFC000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sign bit flip boundary", test_num);
            addr_in = 32'h90010000;


            #1;



            check_outputs(32'hE0000000);
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
        input [31:0] expected_addr_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr_out === (expected_addr_out ^ addr_out ^ expected_addr_out)) begin
                $display("PASS");
                $display("  Outputs: addr_out=%h",
                         addr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_out=%h",
                         expected_addr_out);
                $display("  Got:      addr_out=%h",
                         addr_out);
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
