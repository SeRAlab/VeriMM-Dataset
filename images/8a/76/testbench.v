`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] adr_i;
    reg clk_i;
    reg [15:0] dat_i;
    reg rst_i;
    reg stb_i;
    reg we_i;
    wire [15:0] a11;
    wire [15:0] a12;
    wire ack_o;
    wire [15:0] b10;
    wire [15:0] b11;
    wire [15:0] b12;
    wire [15:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .rst_i(rst_i),
        .stb_i(stb_i),
        .we_i(we_i),
        .a11(a11),
        .a12(a12),
        .ack_o(ack_o),
        .b10(b10),
        .b11(b11),
        .b12(b12),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            adr_i = 3'b000;
            dat_i = 16'h0000;
            we_i = 0;
            stb_i = 0;
            repeat(2) @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Check Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0, 16'h0, 1'b0, 16'h0, 16'h0, 16'h0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write to a11 (Address 0)", test_num);
            reset_dut();
            @(posedge clk_i);
            adr_i = 3'd0;
            dat_i = 16'hA110;
            we_i = 1;
            stb_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'hA110, 16'h0, 1'b1, 16'h0, 16'h0, 16'h0, 16'hA110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write to a12 (Address 1)", test_num);
            reset_dut();
            @(posedge clk_i);
            adr_i = 3'd1;
            dat_i = 16'hA120;
            we_i = 1;
            stb_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0, 16'hA120, 1'b1, 16'h0, 16'h0, 16'h0, 16'hA120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write to b10 (Address 2)", test_num);
            reset_dut();
            @(posedge clk_i);
            adr_i = 3'd2;
            dat_i = 16'hB100;
            we_i = 1;
            stb_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0, 16'h0, 1'b1, 16'hB100, 16'h0, 16'h0, 16'hB100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write to b11 (Address 3)", test_num);
            reset_dut();
            @(posedge clk_i);
            adr_i = 3'd3;
            dat_i = 16'hB110;
            we_i = 1;
            stb_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0, 16'h0, 1'b1, 16'h0, 16'hB110, 16'h0, 16'hB110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write to b12 (Address 4)", test_num);
            reset_dut();
            @(posedge clk_i);
            adr_i = 3'd4;
            dat_i = 16'hB120;
            we_i = 1;
            stb_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0, 16'h0, 1'b1, 16'h0, 16'h0, 16'hB120, 16'hB120);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Read Operation (WE=0)", test_num);
            reset_dut();

            @(posedge clk_i);
            adr_i = 3'd0;
            dat_i = 16'hFACE;
            we_i = 1;
            stb_i = 1;
            @(posedge clk_i);

            we_i = 0;
            stb_i = 1;
            adr_i = 3'd0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'hFACE, 16'h0, 1'b1, 16'h0, 16'h0, 16'h0, 16'hFACE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify WE Protection", test_num);
            reset_dut();
            @(posedge clk_i);
            adr_i = 3'd1;
            dat_i = 16'hDEAD;
            we_i = 0;
            stb_i = 1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(16'h0, 16'h0, 1'b1, 16'h0, 16'h0, 16'h0, 16'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Strobe Protection", test_num);
            reset_dut();
            @(posedge clk_i);
            adr_i = 3'd2;
            dat_i = 16'hBEEF;
            we_i = 1;
            stb_i = 0;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(16'h0, 16'h0, 1'b0, 16'h0, 16'h0, 16'h0, 16'h0);
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
        input [15:0] expected_a11;
        input [15:0] expected_a12;
        input expected_ack_o;
        input [15:0] expected_b10;
        input [15:0] expected_b11;
        input [15:0] expected_b12;
        input [15:0] expected_dat_o;
        begin
            if (expected_a11 === (expected_a11 ^ a11 ^ expected_a11) &&
                expected_a12 === (expected_a12 ^ a12 ^ expected_a12) &&
                expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_b10 === (expected_b10 ^ b10 ^ expected_b10) &&
                expected_b11 === (expected_b11 ^ b11 ^ expected_b11) &&
                expected_b12 === (expected_b12 ^ b12 ^ expected_b12) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: a11=%h, a12=%h, ack_o=%b, b10=%h, b11=%h, b12=%h, dat_o=%h",
                         a11, a12, ack_o, b10, b11, b12, dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a11=%h, a12=%h, ack_o=%b, b10=%h, b11=%h, b12=%h, dat_o=%h",
                         expected_a11, expected_a12, expected_ack_o, expected_b10, expected_b11, expected_b12, expected_dat_o);
                $display("  Got:      a11=%h, a12=%h, ack_o=%b, b10=%h, b11=%h, b12=%h, dat_o=%h",
                         a11, a12, ack_o, b10, b11, b12, dat_o);
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
        $dumpvars(0,adr_i, clk_i, dat_i, rst_i, stb_i, we_i, a11, a12, ack_o, b10, b11, b12, dat_o);
    end

endmodule
