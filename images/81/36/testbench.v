`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg fetch;
    reg [12:0] ir_addr;
    reg [12:0] pc_addr;
    wire [12:0] addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fetch(fetch),
        .ir_addr(ir_addr),
        .pc_addr(pc_addr),
        .addr(addr)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Fetch high, select pc_addr (1FFF)", test_num);
            fetch = 1'b1;
            pc_addr = 13'h1FFF;
            ir_addr = 13'h0000;
            #1;

            check_outputs(13'h1FFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Fetch low, select ir_addr (1FFF)", test_num);
            fetch = 1'b0;
            pc_addr = 13'h0000;
            ir_addr = 13'h1FFF;
            #1;

            check_outputs(13'h1FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fetch high, select pc_addr (0AAA)", test_num);
            fetch = 1'b1;
            pc_addr = 13'h0AAA;
            ir_addr = 13'h0555;
            #1;

            check_outputs(13'h0AAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Fetch low, select ir_addr (0555)", test_num);
            fetch = 1'b0;
            pc_addr = 13'h0AAA;
            ir_addr = 13'h0555;
            #1;

            check_outputs(13'h0555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Fetch high, select pc_addr (0000)", test_num);
            fetch = 1'b1;
            pc_addr = 13'h0000;
            ir_addr = 13'h1FFF;
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Fetch low, select ir_addr (0000)", test_num);
            fetch = 1'b0;
            pc_addr = 13'h1FFF;
            ir_addr = 13'h0000;
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: pc_addr change while fetch=1", test_num);
            fetch = 1'b1;
            ir_addr = 13'h0123;
            pc_addr = 13'h1ABC;
            #1;

            check_outputs(13'h1ABC);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: ir_addr change while fetch=0", test_num);
            fetch = 1'b0;
            pc_addr = 13'h1ABC;
            ir_addr = 13'h0123;
            #1;

            check_outputs(13'h0123);
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
        input [12:0] expected_addr;
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
