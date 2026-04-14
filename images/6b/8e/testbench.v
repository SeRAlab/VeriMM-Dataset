`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] E_Forward;
    reg [31:0] M_Forward;
    reg [31:0] RD2;
    reg [1:0] selet;
    wire [31:0] rt_final;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E_Forward(E_Forward),
        .M_Forward(M_Forward),
        .RD2(RD2),
        .selet(selet),
        .rt_final(rt_final)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select RD2 (selet=0)", test_num);
        RD2 = 32'hAAAA_BBBB;
        E_Forward = 32'h1111_2222;
        M_Forward = 32'h3333_4444;
        selet = 2'b00;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select E_Forward (selet=1)", test_num);
        RD2 = 32'hAAAA_BBBB;
        E_Forward = 32'h1111_2222;
        M_Forward = 32'h3333_4444;
        selet = 2'b01;
        #1;

        check_outputs(32'h1111_2222);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select M_Forward (selet=2)", test_num);
        RD2 = 32'hAAAA_BBBB;
        E_Forward = 32'h1111_2222;
        M_Forward = 32'h3333_4444;
        selet = 2'b10;
        #1;

        check_outputs(32'h3333_4444);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Default/Invalid (selet=3)", test_num);
        RD2 = 32'hFFFF_FFFF;
        E_Forward = 32'hEEEE_EEEE;
        M_Forward = 32'hDDDD_DDDD;
        selet = 2'b11;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero", test_num);
        RD2 = 32'h0;
        E_Forward = 32'h0;
        M_Forward = 32'h0;
        selet = 2'b10;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max values", test_num);
        RD2 = 32'hFFFF_FFFF;
        E_Forward = 32'hFFFF_FFFF;
        M_Forward = 32'hFFFF_FFFF;
        selet = 2'b01;
        #1;

        check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_rt_final;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rt_final === (expected_rt_final ^ rt_final ^ expected_rt_final)) begin
                $display("PASS");
                $display("  Outputs: rt_final=%h",
                         rt_final);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rt_final=%h",
                         expected_rt_final);
                $display("  Got:      rt_final=%h",
                         rt_final);
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
