`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg block;
    reg div_exc;
    reg end_seq;
    reg [5:0] ftype;
    reg iflm;
    reg iflss;
    reg intr;
    reg need_imm;
    reg need_modrm;
    reg need_off;
    reg next_in_exec;
    reg next_in_opco;
    reg nmir;
    reg of;
    reg prefix;
    reg [2:0] state;
    reg tflm;
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
        .iflm(iflm),
        .iflss(iflss),
        .intr(intr),
        .need_imm(need_imm),
        .need_modrm(need_modrm),
        .need_off(need_off),
        .next_in_exec(next_in_exec),
        .next_in_opco(next_in_opco),
        .nmir(nmir),
        .of(of),
        .prefix(prefix),
        .state(state),
        .tflm(tflm),
        .next_state(next_state)
    );
    task reset_inputs;

        begin
            block = 0; div_exc = 0; end_seq = 0; ftype = 0;
            iflm = 0; iflss = 0; intr = 0; need_imm = 0;
            need_modrm = 0; need_off = 0; next_in_exec = 0;
            next_in_opco = 0; nmir = 0; of = 0; prefix = 0;
            state = 0; tflm = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b000;
        prefix = 1'b0;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b000;
        prefix = 1'b1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b001;
        need_modrm = 1'b1;
        #1;

        check_outputs(3'b012);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b001;
        need_modrm = 1'b0;
        need_off = 1'b1;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b001;
        need_modrm = 1'b0;
        need_off = 1'b0;
        need_imm = 1'b1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b001;
        need_modrm = 0; need_off = 0; need_imm = 0;
        next_in_exec = 1'b1;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b010;
        need_off = 1'b1;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b011;
        nmir = 1'b1;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b101;
        end_seq = 1'b1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b101;
        div_exc = 1'b1;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b010;
        block = 1'b1;
        need_off = 1'b1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        reset_inputs();
        state = 3'b101;
        intr = 1'b1;
        iflm = 1'b1;
        #1;

        check_outputs(3'b110);
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
