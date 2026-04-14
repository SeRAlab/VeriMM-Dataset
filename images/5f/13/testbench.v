`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DataOut;
    reg IRWre;
    wire [25:0] add;
    wire [15:0] immediate;
    wire [5:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [31:0] sa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DataOut(DataOut),
        .IRWre(IRWre),
        .add(add),
        .immediate(immediate),
        .opcode(opcode),
        .rd(rd),
        .rs(rs),
        .rt(rt),
        .sa(sa)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            IRWre = 0;
            DataOut = 32'h0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Write (A5A5A5A5)", test_num);
            IRWre = 1;
            DataOut = 32'hA5A5A5A5;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(26'h1A5A5A5, 16'hA5A5, 6'h29, 5'h14, 5'h0D, 5'h05, 32'h16);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Persistence (Write Disable)", test_num);


            IRWre = 1;
            DataOut = 32'hAAAAAAAA;
            @(posedge CLK);
            #2;


            IRWre = 0;
            DataOut = 32'h55555555;
            @(posedge CLK);
            #2;



            #1;




            check_outputs(26'h2AAAAAA, 16'hAAAA, 6'h2A, 5'h15, 5'h15, 5'h0A, 32'h0A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: All Ones Instruction", test_num);
            IRWre = 1;
            DataOut = 32'hFFFFFFFF;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(26'h3FFFFFF, 16'hFFFF, 6'h3F, 5'h1F, 5'h1F, 5'h1F, 32'h1F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: All Zeros Instruction", test_num);
            IRWre = 1;
            DataOut = 32'h00000000;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(26'h0, 16'h0, 6'h0, 5'h0, 5'h0, 5'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Specific Bit Patterns (12345678)", test_num);
            IRWre = 1;
            DataOut = 32'h12345678;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(26'h2345678, 16'h5678, 6'h04, 5'h0A, 5'h11, 5'h14, 32'h19);
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
        input [25:0] expected_add;
        input [15:0] expected_immediate;
        input [5:0] expected_opcode;
        input [4:0] expected_rd;
        input [4:0] expected_rs;
        input [4:0] expected_rt;
        input [31:0] expected_sa;
        begin
            if (expected_add === (expected_add ^ add ^ expected_add) &&
                expected_immediate === (expected_immediate ^ immediate ^ expected_immediate) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd) &&
                expected_rs === (expected_rs ^ rs ^ expected_rs) &&
                expected_rt === (expected_rt ^ rt ^ expected_rt) &&
                expected_sa === (expected_sa ^ sa ^ expected_sa)) begin
                $display("PASS");
                $display("  Outputs: add=%h, immediate=%h, opcode=%h, rd=%h, rs=%h, rt=%h, sa=%h",
                         add, immediate, opcode, rd, rs, rt, sa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add=%h, immediate=%h, opcode=%h, rd=%h, rs=%h, rt=%h, sa=%h",
                         expected_add, expected_immediate, expected_opcode, expected_rd, expected_rs, expected_rt, expected_sa);
                $display("  Got:      add=%h, immediate=%h, opcode=%h, rd=%h, rs=%h, rt=%h, sa=%h",
                         add, immediate, opcode, rd, rs, rt, sa);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, DataOut, IRWre, add, immediate, opcode, rd, rs, rt, sa);
    end

endmodule
