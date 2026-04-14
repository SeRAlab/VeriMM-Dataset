`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [7:0] da;
    reg [7:0] db;
    reg [7:0] dc;
    reg [7:0] dd;
    reg [7:0] de;
    reg [7:0] df;
    reg [7:0] dg;
    reg [7:0] dh;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .da(da),
        .db(db),
        .dc(dc),
        .dd(dd),
        .de(de),
        .df(df),
        .dg(dg),
        .dh(dh),
        .q(q)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 3'b000;
            da = 8'h11; db = 8'h22; dc = 8'h33; dd = 8'h44;
            de = 8'h55; df = 8'h66; dg = 8'h77; dh = 8'h88;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 3'b001;
            da = 8'hAA; db = 8'hBB; dc = 8'hCC; dd = 8'hDD;
            de = 8'hEE; df = 8'hFF; dg = 8'h00; dh = 8'h11;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 3'b010;
            da = 8'h01; db = 8'h02; dc = 8'h03; dd = 8'h04;
            de = 8'h05; df = 8'h06; dg = 8'h07; dh = 8'h08;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 3'b011;
            da = 8'hF0; db = 8'hE1; dc = 8'hD2; dd = 8'hC3;
            de = 8'hB4; df = 8'hA5; dg = 8'h96; dh = 8'h87;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 3'b100;
            da = 8'h10; db = 8'h20; dc = 8'h30; dd = 8'h40;
            de = 8'h50; df = 8'h60; dg = 8'h70; dh = 8'h80;
            #1;

            check_outputs(8'h50);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 3'b101;
            da = 8'h0F; db = 8'h1F; dc = 8'h2F; dd = 8'h3F;
            de = 8'h4F; df = 8'h5F; dg = 8'h6F; dh = 8'h7F;
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 3'b110;
            da = 8'h55; db = 8'hAA; dc = 8'h33; dd = 8'hCC;
            de = 8'h0F; df = 8'hF0; dg = 8'hBE; dh = 8'hEF;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 3'b111;
            da = 8'hDE; db = 8'hAD; dc = 8'hBE; dd = 8'hEF;
            de = 8'hCA; df = 8'hFE; dg = 8'hBA; dh = 8'hBE;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 3'd3;
            da = 8'h00; db = 8'h00; dc = 8'h00; dd = 8'h00;
            de = 8'h00; df = 8'h00; dg = 8'h00; dh = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 3'd5;
            da = 8'hFF; db = 8'hFF; dc = 8'hFF; dd = 8'hFF;
            de = 8'hFF; df = 8'hFF; dg = 8'hFF; dh = 8'hFF;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
