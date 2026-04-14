`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] hcount;
    reg [9:0] vcount;
    wire [16:0] addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hcount(hcount),
        .vcount(vcount),
        .addr(addr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            hcount = 10'd0;
            vcount = 10'd0;

            #1;


            check_outputs(17'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            hcount = 10'd1;
            vcount = 10'd1;

            #1;


            check_outputs(17'h00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            hcount = 10'd2;
            vcount = 10'd0;

            #1;


            check_outputs(17'h00001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            hcount = 10'd0;
            vcount = 10'd2;

            #1;


            check_outputs(17'h00140);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            hcount = 10'd20;
            vcount = 10'd20;

            #1;


            check_outputs(17'h00C8A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            hcount = 10'd640;
            vcount = 10'd480;

            #1;


            check_outputs(17'h12D40);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            hcount = 10'd1023;
            vcount = 10'd1023;



            #1;




            check_outputs(17'h080BF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            hcount = 10'd512;
            vcount = 10'd512;

            #1;


            check_outputs(17'h14100);
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
        input [16:0] expected_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr === (expected_addr ^ addr ^ expected_addr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h",
                         addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h",
                         expected_addr);
                $display("  Got:      addr=%h",
                         addr);
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
