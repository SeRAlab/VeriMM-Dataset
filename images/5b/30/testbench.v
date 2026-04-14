`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] addr_fsm_in;
    reg [5:0] addr_in;
    reg sel;
    reg w_in;
    wire [5:0] addr_out;
    wire w_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_fsm_in(addr_fsm_in),
        .addr_in(addr_in),
        .sel(sel),
        .w_in(w_in),
        .addr_out(addr_out),
        .w_out(w_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: sel=1, addr_in=6'h0A, addr_fsm_in=6'h3F, w_in=1", test_num);

        sel = 1'b1;
        addr_in = 6'h0A;
        addr_fsm_in = 6'h3F;
        w_in = 1'b1;

        #1;


        check_outputs(6'h0A, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: sel=1, addr_in=6'h15, addr_fsm_in=6'h00, w_in=0", test_num);
        sel = 1'b1;
        addr_in = 6'h15;
        addr_fsm_in = 6'h00;
        w_in = 1'b0;

        #1;


        check_outputs(6'h15, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: sel=0, addr_in=6'h22, addr_fsm_in=6'h07, w_in=1", test_num);
        sel = 1'b0;
        addr_in = 6'h22;
        addr_fsm_in = 6'h07;
        w_in = 1'b1;

        #1;


        check_outputs(6'h07, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: sel=0, addr_in=6'h00, addr_fsm_in=6'h30, w_in=0", test_num);
        sel = 1'b0;
        addr_in = 6'h00;
        addr_fsm_in = 6'h30;
        w_in = 1'b0;

        #1;


        check_outputs(6'h30, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All inputs logic 1", test_num);
        sel = 1'b1;
        addr_in = 6'h3F;
        addr_fsm_in = 6'h3F;
        w_in = 1'b1;

        #1;


        check_outputs(6'h3F, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All inputs logic 0", test_num);
        sel = 1'b0;
        addr_in = 6'h00;
        addr_fsm_in = 6'h00;
        w_in = 1'b0;

        #1;


        check_outputs(6'h00, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Toggle addr_fsm_in while sel=1", test_num);
        sel = 1'b1;
        addr_in = 6'h2A;
        addr_fsm_in = 6'h00;
        w_in = 1'b1;
        #5;
        addr_fsm_in = 6'h33;

        #1;


        check_outputs(6'h2A, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Toggle addr_in while sel=0", test_num);
        sel = 1'b0;
        addr_in = 6'h00;
        addr_fsm_in = 6'h11;
        w_in = 1'b0;
        #5;
        addr_in = 6'h3F;

        #1;


        check_outputs(6'h11, 1'b0);
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
        input [5:0] expected_addr_out;
        input expected_w_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr_out === (expected_addr_out ^ addr_out ^ expected_addr_out) &&
                expected_w_out === (expected_w_out ^ w_out ^ expected_w_out)) begin
                $display("PASS");
                $display("  Outputs: addr_out=%h, w_out=%b",
                         addr_out, w_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_out=%h, w_out=%b",
                         expected_addr_out, expected_w_out);
                $display("  Got:      addr_out=%h, w_out=%b",
                         addr_out, w_out);
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
