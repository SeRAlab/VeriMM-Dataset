`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] sel;
    reg [31:0] x;
    reg [31:0] y;
    wire c;
    wire [31:0] o;
    wire s;
    wire v;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .x(x),
        .y(y),
        .c(c),
        .o(o),
        .s(s),
        .v(v),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        sel = 4'b0000;
        x = 32'd10;
        y = 32'd20;

        #1;


        check_outputs(1'b0, 32'd30, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        sel = 4'b0000;
        x = 32'hFFFFFFFF;
        y = 32'h00000001;

        #1;


        check_outputs(1'b1, 32'h0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        sel = 4'b0000;
        x = 32'h7FFFFFFF;
        y = 32'h00000001;

        #1;


        check_outputs(1'b0, 32'h80000000, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        sel = 4'b0001;
        x = 32'd50;
        y = 32'd20;

        #1;


        check_outputs(1'b0, 32'd30, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        sel = 4'b0001;
        x = 32'd10;
        y = 32'd20;

        #1;


        check_outputs(1'b1, 32'hFFFFFFF6, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        sel = 4'b0010;
        x = 32'hAAAA5555;
        y = 32'hF0F0F0F0;

        #1;


        check_outputs(1'b0, 32'hA0A05050, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        sel = 4'b0011;
        x = 32'hAAAA5555;
        y = 32'h5555AAAA;

        #1;


        check_outputs(1'b0, 32'hFFFFFFFF, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        sel = 4'b0100;
        x = 32'h12345678;
        y = 32'h12345678;

        #1;


        check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        sel = 4'b0101;
        x = 32'hFFFFFFFF;
        y = 32'h00000001;

        #1;


        check_outputs(1'b0, 32'h1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        sel = 4'b0110;
        x = 32'hFFFFFFFF;
        y = 32'h00000001;

        #1;


        check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        sel = 4'b0111;
        x = 32'h00000001;
        y = 32'd4;

        #1;


        check_outputs(1'b0, 32'h00000010, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        sel = 4'b1000;
        x = 32'h80000000;
        y = 32'd1;

        #1;


        check_outputs(1'b0, 32'h40000000, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        sel = 4'b1001;
        x = 32'h80000000;
        y = 32'd1;

        #1;


        check_outputs(1'b0, 32'hC0000000, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        sel = 4'b0001;
        x = 32'h80000000;
        y = 32'h00000001;

        #1;


        check_outputs(1'b0, 32'h7FFFFFFF, 1'b0, 1'b1, 1'b0);
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
        input expected_c;
        input [31:0] expected_o;
        input expected_s;
        input expected_v;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_o === (expected_o ^ o ^ expected_o) &&
                expected_s === (expected_s ^ s ^ expected_s) &&
                expected_v === (expected_v ^ v ^ expected_v) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: c=%b, o=%h, s=%b, v=%b, z=%b",
                         c, o, s, v, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, o=%h, s=%b, v=%b, z=%b",
                         expected_c, expected_o, expected_s, expected_v, expected_z);
                $display("  Got:      c=%b, o=%h, s=%b, v=%b, z=%b",
                         c, o, s, v, z);
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
