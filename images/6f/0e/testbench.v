`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] imm;
    reg [1:0] npc_sel;
    reg [29:0] pcout;
    reg [25:0] taraddr;
    reg zero;
    wire [29:0] jal_ins;
    wire [29:0] newpc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm(imm),
        .npc_sel(npc_sel),
        .pcout(pcout),
        .taraddr(taraddr),
        .zero(zero),
        .jal_ins(jal_ins),
        .newpc(newpc)
    );
    task init_inputs;

        begin
            imm = 16'b0;
            npc_sel = 2'b0;
            pcout = 30'b0;
            taraddr = 26'b0;
            zero = 1'b0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        init_inputs();
        pcout = 30'h0000_0005;
        npc_sel = 2'b00;

        #1;


        check_outputs(30'h0000_0006, 30'h0000_0006);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        init_inputs();
        pcout = 30'h0000_0010;
        imm = 16'h0004;
        zero = 1'b1;
        npc_sel = 2'b01;

        #1;


        check_outputs(30'h0000_0011, 30'h0000_0014);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        init_inputs();
        pcout = 30'h0000_0010;
        imm = 16'hFFFF;
        zero = 1'b1;
        npc_sel = 2'b01;

        #1;


        check_outputs(30'h0000_0011, 30'h0000_000F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        init_inputs();
        pcout = 30'h0000_0020;
        imm = 16'h0008;
        zero = 1'b0;
        npc_sel = 2'b01;

        #1;


        check_outputs(30'h0000_0021, 30'h0000_0021);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        init_inputs();
        pcout = 30'h1AAAAAAA;
        taraddr = 26'h3FFFFFF;
        npc_sel = 2'b10;


        #1;



        check_outputs(30'h1AAAAAAB, 30'h1BFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        init_inputs();
        pcout = 30'h3FFF_FFFE;
        npc_sel = 2'b00;

        #1;


        check_outputs(30'h3FFF_FFFF, 30'h3FFF_FFFF);
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
        input [29:0] expected_jal_ins;
        input [29:0] expected_newpc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_jal_ins === (expected_jal_ins ^ jal_ins ^ expected_jal_ins) &&
                expected_newpc === (expected_newpc ^ newpc ^ expected_newpc)) begin
                $display("PASS");
                $display("  Outputs: jal_ins=%h, newpc=%h",
                         jal_ins, newpc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jal_ins=%h, newpc=%h",
                         expected_jal_ins, expected_newpc);
                $display("  Got:      jal_ins=%h, newpc=%h",
                         jal_ins, newpc);
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
