`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_addr_in;
    reg [7:0] pc_addr_in;
    reg sel;
    wire [7:0] mux8_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_addr_in(data_addr_in),
        .pc_addr_in(pc_addr_in),
        .sel(sel),
        .mux8_out(mux8_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: sel=0, pc=00, data=FF", test_num);
        sel = 0;
        pc_addr_in = 8'h00;
        data_addr_in = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: sel=0, pc=FF, data=00", test_num);
        sel = 0;
        pc_addr_in = 8'hFF;
        data_addr_in = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: sel=0, pc=A5, data=5A", test_num);
        sel = 0;
        pc_addr_in = 8'hA5;
        data_addr_in = 8'h5A;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: sel=1, pc=FF, data=00", test_num);
        sel = 1;
        pc_addr_in = 8'hFF;
        data_addr_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: sel=1, pc=00, data=FF", test_num);
        sel = 1;
        pc_addr_in = 8'h00;
        data_addr_in = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: sel=1, pc=A5, data=5A", test_num);
        sel = 1;
        pc_addr_in = 8'hA5;
        data_addr_in = 8'h5A;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switching sel (0 to 1) with static inputs", test_num);
        pc_addr_in = 8'h12;
        data_addr_in = 8'h34;
        sel = 0;
        #5;
        sel = 1;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switching pc_addr_in with sel=0", test_num);
        sel = 0;
        data_addr_in = 8'h00;
        pc_addr_in = 8'hAA;
        #5;
        pc_addr_in = 8'h55;
        #1;

        check_outputs(8'h55);
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
        input [7:0] expected_mux8_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux8_out === (expected_mux8_out ^ mux8_out ^ expected_mux8_out)) begin
                $display("PASS");
                $display("  Outputs: mux8_out=%h",
                         mux8_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux8_out=%h",
                         expected_mux8_out);
                $display("  Got:      mux8_out=%h",
                         mux8_out);
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
