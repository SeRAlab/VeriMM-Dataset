`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aclk;
    reg [11:0] m_axi_araddr;
    reg [47:0] m_payload_i_reg;
    reg m_valid_i_reg;
    reg si_rs_arvalid;
    wire [3:0] D;
    wire E;
    wire [3:0] O;
    wire [19:0] Q;
    wire [3:0] S;
    wire m_axi_arready;
    wire r_rlast;
    wire sel_first;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclk(aclk),
        .m_axi_araddr(m_axi_araddr),
        .m_payload_i_reg(m_payload_i_reg),
        .m_valid_i_reg(m_valid_i_reg),
        .si_rs_arvalid(si_rs_arvalid),
        .D(D),
        .E(E),
        .O(O),
        .Q(Q),
        .S(S),
        .m_axi_arready(m_axi_arready),
        .r_rlast(r_rlast),
        .sel_first(sel_first)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: System Idle", test_num);
            m_axi_araddr = 12'h0;
            m_payload_i_reg = 48'h0;
            m_valid_i_reg = 1'b0;
            si_rs_arvalid = 1'b0;

            @(posedge aclk);
            #2;

            #1;


            check_outputs(4'h0, 1'b0, 4'h0, 20'h00000, 4'h0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: AXI Read Valid (Addr 0x123)", test_num);
            m_axi_araddr = 12'h123;
            m_payload_i_reg = 48'h0;
            m_valid_i_reg = 1'b0;
            si_rs_arvalid = 1'b1;

            @(posedge aclk);
            #2;


            #1;



            check_outputs(4'h0, 1'b1, 4'h0, 20'h00123, 4'h1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: AXI Read Valid (Addr 0xF00 - High Bit)", test_num);
            m_axi_araddr = 12'hF00;
            m_payload_i_reg = 48'h0;
            m_valid_i_reg = 1'b0;
            si_rs_arvalid = 1'b1;

            @(posedge aclk);
            #2;
            #1;

            check_outputs(4'h0, 1'b1, 4'h0, 20'h00F00, 4'h1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Payload Reg Activity", test_num);
            m_axi_araddr = 12'h0;
            m_payload_i_reg = 48'hAAAA_BBBB_CCCC;
            m_valid_i_reg = 1'b1;
            si_rs_arvalid = 1'b0;

            @(posedge aclk);
            #2;

            #1;


            check_outputs(4'hA, 1'b0, 4'hC, 20'h00000, 4'h0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous AXI and Payload", test_num);
            m_axi_araddr = 12'hABC;
            m_payload_i_reg = 48'h1234_5678_9ABC;
            m_valid_i_reg = 1'b1;
            si_rs_arvalid = 1'b1;

            @(posedge aclk);
            #2;
            #1;

            check_outputs(4'h1, 1'b1, 4'hC, 20'h00ABC, 4'hF, 1'b0, 1'b1, 1'b1);
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
        input [3:0] expected_D;
        input expected_E;
        input [3:0] expected_O;
        input [19:0] expected_Q;
        input [3:0] expected_S;
        input expected_m_axi_arready;
        input expected_r_rlast;
        input expected_sel_first;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_E === (expected_E ^ E ^ expected_E) &&
                expected_O === (expected_O ^ O ^ expected_O) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_m_axi_arready === (expected_m_axi_arready ^ m_axi_arready ^ expected_m_axi_arready) &&
                expected_r_rlast === (expected_r_rlast ^ r_rlast ^ expected_r_rlast) &&
                expected_sel_first === (expected_sel_first ^ sel_first ^ expected_sel_first)) begin
                $display("PASS");
                $display("  Outputs: D=%h, E=%b, O=%h, Q=%h, S=%h, m_axi_arready=%b, r_rlast=%b, sel_first=%b",
                         D, E, O, Q, S, m_axi_arready, r_rlast, sel_first);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, E=%b, O=%h, Q=%h, S=%h, m_axi_arready=%b, r_rlast=%b, sel_first=%b",
                         expected_D, expected_E, expected_O, expected_Q, expected_S, expected_m_axi_arready, expected_r_rlast, expected_sel_first);
                $display("  Got:      D=%h, E=%b, O=%h, Q=%h, S=%h, m_axi_arready=%b, r_rlast=%b, sel_first=%b",
                         D, E, O, Q, S, m_axi_arready, r_rlast, sel_first);
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
