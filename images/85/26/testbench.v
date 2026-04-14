`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg block;
    reg div_exc;
    reg end_seq;
    reg [5:0] ftype;
    reg ifl;
    reg intr;
    reg need_imm;
    reg need_modrm;
    reg need_off;
    reg next_in_exec;
    reg next_in_opco;
    reg of;
    reg prefix;
    reg [2:0] state;
    wire [2:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .block(block),
        .div_exc(div_exc),
        .end_seq(end_seq),
        .ftype(ftype),
        .ifl(ifl),
        .intr(intr),
        .need_imm(need_imm),
        .need_modrm(need_modrm),
        .need_off(need_off),
        .next_in_exec(next_in_exec),
        .next_in_opco(next_in_opco),
        .of(of),
        .prefix(prefix),
        .state(state),
        .next_state(next_state)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: State 0, Prefix signal active - Expecting Loop in S0", test_num);
        state = 3'd0; prefix = 1; need_modrm = 0; need_off = 0; need_imm = 0;
        end_seq = 0; ftype = 6'b0; of = 0; next_in_opco = 0; next_in_exec = 0;
        block = 0; div_exc = 0; intr = 0; ifl = 0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: State 0, Prefix signal inactive - Expecting transition to S1", test_num);
        state = 3'd0; prefix = 0;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: State 1, Need ModRM - Expecting transition to S2", test_num);
        state = 3'd1; need_modrm = 1; need_off = 0; need_imm = 0;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: State 1, Need Offset - Expecting transition to S3", test_num);
        state = 3'd1; need_modrm = 0; need_off = 1; need_imm = 0;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: State 1, Need Immediate - Expecting transition to S4", test_num);
        state = 3'd1; need_modrm = 0; need_off = 0; need_imm = 1;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: State 1, Simple instruction - Expecting transition to S5", test_num);
        state = 3'd1; need_modrm = 0; need_off = 0; need_imm = 0;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: State 2, Need Offset - Expecting transition to S3", test_num);
        state = 3'd2; need_off = 1; need_imm = 0;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: State 3, Need Immediate - Expecting transition to S4", test_num);
        state = 3'd3; need_imm = 1;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: State 4 to Execute", test_num);
        state = 3'd4;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: State 5, Execution Blocked - Expecting stay in S5", test_num);
        state = 3'd5; block = 1; end_seq = 0;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: State 5, Sequence End - Expecting return to S0", test_num);
        state = 3'd5; block = 0; end_seq = 1; intr = 0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: State 5, Division Exception - Expecting transition to S6", test_num);
        state = 3'd5; div_exc = 1;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test %0d: State 5, End Seq + Interrupt - Expecting transition to S6", test_num);
        state = 3'd5; end_seq = 1; intr = 1; ifl = 1; block = 0;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test %0d: State 6 to S0 transition", test_num);
        state = 3'd6;
        #1;

        check_outputs(3'd0);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
        input [2:0] expected_next_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
