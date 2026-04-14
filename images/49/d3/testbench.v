`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclk;
    reg areset_d1;
    reg b_push;
    reg [8:0] in;
    reg [1:0] m_axi_bresp;
    reg m_axi_bvalid;
    reg si_rs_bready;
    wire cnt_read_reg_0_rep;
    wire [1:0] cnt_read_reg_1_rep_0;
    wire m_axi_bready;
    wire out;
    wire si_rs_bvalid;
    wire [1:0] skid_buffer_reg_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclk(aclk),
        .areset_d1(areset_d1),
        .b_push(b_push),
        .in(in),
        .m_axi_bresp(m_axi_bresp),
        .m_axi_bvalid(m_axi_bvalid),
        .si_rs_bready(si_rs_bready),
        .cnt_read_reg_0_rep(cnt_read_reg_0_rep),
        .cnt_read_reg_1_rep_0(cnt_read_reg_1_rep_0),
        .m_axi_bready(m_axi_bready),
        .out(out),
        .si_rs_bvalid(si_rs_bvalid),
        .skid_buffer_reg_1(skid_buffer_reg_1)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            areset_d1 = 1;
            b_push = 0;
            si_rs_bready = 0;
            m_axi_bresp = 2'b00;
            m_axi_bvalid = 0;
            in = 9'h000;
            @(posedge aclk);
            #1 areset_d1 = 0;
            @(posedge aclk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(
                1'b0,
                2'b00,
                1'b1,
                1'b0,
                1'b0,
                2'b00
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Write Response Handshake", test_num);
            reset_dut();

            @(posedge aclk);
            m_axi_bvalid = 1;
            m_axi_bresp = 2'b00;
            si_rs_bready = 1;

            @(posedge aclk);
            #1;


            #1;



            check_outputs(
                1'b0,
                2'b00,
                1'b1,
                1'b0,
                1'b1,
                2'b00
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Skid Buffer Storage (Slave Not Ready)", test_num);
            reset_dut();

            @(posedge aclk);
            m_axi_bvalid = 1;
            m_axi_bresp = 2'b10;
            si_rs_bready = 0;

            @(posedge aclk);
            #1;



            #1;




            check_outputs(
                1'b0,
                2'b00,
                1'b1,
                1'b0,
                1'b1,
                2'b10
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Management via b_push", test_num);
            reset_dut();

            @(posedge aclk);
            b_push = 1;
            in = 9'h1FF;

            @(posedge aclk);
            #1;



            #1;




            check_outputs(
                1'b1,
                2'b01,
                1'b1,
                1'b0,
                1'b0,
                2'b00
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Concurrent Push and Master Response", test_num);
            reset_dut();

            @(posedge aclk);
            b_push = 1;
            m_axi_bvalid = 1;
            m_axi_bresp = 2'b11;
            si_rs_bready = 1;

            @(posedge aclk);
            #1;

            #1;


            check_outputs(
                1'b1,
                2'b01,
                1'b1,
                1'b0,
                1'b1,
                2'b11
            );
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Push Operations", test_num);
            reset_dut();

            @(posedge aclk);
            b_push = 1;
            @(posedge aclk);
            b_push = 1;
            @(posedge aclk);
            b_push = 0;
            #1;


            #1;



            check_outputs(
                1'b1,
                2'b10,
                1'b1,
                1'b0,
                1'b0,
                2'b00
            );
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
        input expected_cnt_read_reg_0_rep;
        input [1:0] expected_cnt_read_reg_1_rep_0;
        input expected_m_axi_bready;
        input expected_out;
        input expected_si_rs_bvalid;
        input [1:0] expected_skid_buffer_reg_1;
        begin
            if (expected_cnt_read_reg_0_rep === (expected_cnt_read_reg_0_rep ^ cnt_read_reg_0_rep ^ expected_cnt_read_reg_0_rep) &&
                expected_cnt_read_reg_1_rep_0 === (expected_cnt_read_reg_1_rep_0 ^ cnt_read_reg_1_rep_0 ^ expected_cnt_read_reg_1_rep_0) &&
                expected_m_axi_bready === (expected_m_axi_bready ^ m_axi_bready ^ expected_m_axi_bready) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_si_rs_bvalid === (expected_si_rs_bvalid ^ si_rs_bvalid ^ expected_si_rs_bvalid) &&
                expected_skid_buffer_reg_1 === (expected_skid_buffer_reg_1 ^ skid_buffer_reg_1 ^ expected_skid_buffer_reg_1)) begin
                $display("PASS");
                $display("  Outputs: cnt_read_reg_0_rep=%b, cnt_read_reg_1_rep_0=%h, m_axi_bready=%b, out=%b, si_rs_bvalid=%b, skid_buffer_reg_1=%h",
                         cnt_read_reg_0_rep, cnt_read_reg_1_rep_0, m_axi_bready, out, si_rs_bvalid, skid_buffer_reg_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt_read_reg_0_rep=%b, cnt_read_reg_1_rep_0=%h, m_axi_bready=%b, out=%b, si_rs_bvalid=%b, skid_buffer_reg_1=%h",
                         expected_cnt_read_reg_0_rep, expected_cnt_read_reg_1_rep_0, expected_m_axi_bready, expected_out, expected_si_rs_bvalid, expected_skid_buffer_reg_1);
                $display("  Got:      cnt_read_reg_0_rep=%b, cnt_read_reg_1_rep_0=%h, m_axi_bready=%b, out=%b, si_rs_bvalid=%b, skid_buffer_reg_1=%h",
                         cnt_read_reg_0_rep, cnt_read_reg_1_rep_0, m_axi_bready, out, si_rs_bvalid, skid_buffer_reg_1);
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
        $dumpvars(0,aclk, areset_d1, b_push, in, m_axi_bresp, m_axi_bvalid, si_rs_bready, cnt_read_reg_0_rep, cnt_read_reg_1_rep_0, m_axi_bready, out, si_rs_bvalid, skid_buffer_reg_1);
    end

endmodule
