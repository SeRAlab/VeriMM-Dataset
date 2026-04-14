`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] accreg;
    reg [96:0] areg;
    reg mul_rst_l;
    reg mul_step;
    reg rclk;
    reg [63:0] rs1_l;
    reg [63:0] rs2;
    reg se;
    reg si;
    reg valid;
    reg x2;
    wire [135:0] out;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .accreg(accreg),
        .areg(areg),
        .mul_rst_l(mul_rst_l),
        .mul_step(mul_step),
        .rclk(rclk),
        .rs1_l(rs1_l),
        .rs2(rs2),
        .se(se),
        .si(si),
        .valid(valid),
        .x2(x2),
        .out(out),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        rclk = 0;
        forever #5 rclk = ~rclk;
    end

        task reset_dut;

        begin
            mul_rst_l = 0;
            valid = 0;
            rs1_l = 0;
            rs2 = 0;
            mul_step = 0;
            accreg = 0;
            areg = 0;
            x2 = 0;
            se = 0;
            si = 0;
            repeat (5) @(posedge rclk);
            mul_rst_l = 1;
            repeat (2) @(posedge rclk);
        end
        endtask
    task wait_for_done;

        integer timeout;
        begin
            timeout = 0;
            while (so !== 1'b1 && timeout < 100) begin
                @(posedge rclk);
                timeout = timeout + 1;
            end

            @(posedge rclk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 0 * 0", test_num);
            reset_dut();
            rs1_l = 64'h0;
            rs2   = 64'h0;
            valid = 1;
            mul_step = 1;
            @(posedge rclk);
            valid = 0;
            wait_for_done();
            #1;

            check_outputs(136'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 123 * 456", test_num);
            reset_dut();
            rs1_l = 64'd123;
            rs2   = 64'd456;
            valid = 1;
            mul_step = 1;
            @(posedge rclk);
            valid = 0;
            wait_for_done();

            #1;


            check_outputs({120'h0, 16'hDB18}, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 2^32 * 2^32", test_num);
            reset_dut();
            rs1_l = 64'h0000000100000000;
            rs2   = 64'h0000000100000000;
            valid = 1;
            mul_step = 1;
            @(posedge rclk);
            valid = 0;
            wait_for_done();

            #1;


            check_outputs({64'h0, 8'h01, 64'h0}, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max 64-bit * 1", test_num);
            reset_dut();
            rs1_l = 64'hFFFFFFFF_FFFFFFFF;
            rs2   = 64'h1;
            valid = 1;
            mul_step = 1;
            @(posedge rclk);
            valid = 0;
            wait_for_done();
            #1;

            check_outputs({72'h0, 64'hFFFFFFFF_FFFFFFFF}, 1'b1);
        end
        endtask

    task testcase005;

        reg [127:0] expected_prod;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max 64-bit * Max 64-bit", test_num);
            reset_dut();
            rs1_l = 64'hFFFFFFFF_FFFFFFFF;
            rs2   = 64'hFFFFFFFF_FFFFFFFF;
            valid = 1;
            mul_step = 1;
            @(posedge rclk);
            valid = 0;
            wait_for_done();

            expected_prod = 128'hFFFFFFFF_FFFFFFFF_00000000_00000001;
            #1;

            check_outputs({8'h0, expected_prod}, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bit Pattern", test_num);
            reset_dut();
            rs1_l = 64'h55555555_55555555;
            rs2   = 64'h00000000_00000002;
            valid = 1;
            mul_step = 1;
            @(posedge rclk);
            valid = 0;
            wait_for_done();

            #1;


            check_outputs({72'h0, 64'hAAAAAAAA_AAAAAAAA}, 1'b1);
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
        input [135:0] expected_out;
        input expected_so;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: out=%h, so=%b",
                         out, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, so=%b",
                         expected_out, expected_so);
                $display("  Got:      out=%h, so=%b",
                         out, so);
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
        $dumpvars(0,accreg, areg, mul_rst_l, mul_step, rclk, rs1_l, rs2, se, si, valid, x2, out, so);
    end

endmodule
