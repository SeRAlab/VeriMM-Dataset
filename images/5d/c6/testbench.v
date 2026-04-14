`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a_dout;
    reg [7:0] a_dout_en;
    reg [7:0] b_dout;
    reg [7:0] b_dout_en;
    reg [7:0] io_din;
    reg [7:0] sel;
    wire [7:0] a_din;
    wire [7:0] b_din;
    wire [7:0] io_dout;
    wire [7:0] io_dout_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_dout(a_dout),
        .a_dout_en(a_dout_en),
        .b_dout(b_dout),
        .b_dout_en(b_dout_en),
        .io_din(io_din),
        .sel(sel),
        .a_din(a_din),
        .b_din(b_din),
        .io_dout(io_dout),
        .io_dout_en(io_dout_en)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Channel A (sel=1)", test_num);


        sel = 8'h01;
        a_dout = 8'hA5;
        a_dout_en = 8'hFF;
        b_dout = 8'h5A;
        b_dout_en = 8'h00;
        io_din = 8'h12;






        #1;







        check_outputs(8'h12, 8'h00, 8'hA5, 8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Channel B (sel=0)", test_num);


        sel = 8'h00;
        a_dout = 8'hA5;
        a_dout_en = 8'hFF;
        b_dout = 8'hC3;
        b_dout_en = 8'h0F;
        io_din = 8'h34;






        #1;







        check_outputs(8'h00, 8'h34, 8'hC3, 8'h0F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Channel A All Ones", test_num);

        sel = 8'h01;
        a_dout = 8'hFF;
        a_dout_en = 8'hFF;
        b_dout = 8'h00;
        b_dout_en = 8'h00;
        io_din = 8'hFF;

        #1;


        check_outputs(8'hFF, 8'h00, 8'hFF, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Channel B All Zeros", test_num);

        sel = 8'h00;
        a_dout = 8'hFF;
        a_dout_en = 8'hFF;
        b_dout = 8'h00;
        b_dout_en = 8'h00;
        io_din = 8'h00;

        #1;


        check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable mask check on Channel A", test_num);

        sel = 8'h01;
        a_dout = 8'hAA;
        a_dout_en = 8'hF0;
        b_dout = 8'h55;
        b_dout_en = 8'h0F;
        io_din = 8'hE7;

        #1;


        check_outputs(8'hE7, 8'h00, 8'hAA, 8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Selection Switch Logic", test_num);


        a_dout = 8'h11; a_dout_en = 8'h11;
        b_dout = 8'h22; b_dout_en = 8'h22;
        io_din = 8'h99;


        sel = 8'h01;
        #5;


        sel = 8'h00;
        #1;

        check_outputs(8'h00, 8'h99, 8'h22, 8'h22);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking ones pattern", test_num);

        sel = 8'h01;
        a_dout = 8'h00;
        a_dout_en = 8'h00;
        b_dout = 8'h00;
        b_dout_en = 8'h00;
        io_din = 8'h80;

        #1;


        check_outputs(8'h80, 8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_a_din;
        input [7:0] expected_b_din;
        input [7:0] expected_io_dout;
        input [7:0] expected_io_dout_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_din === (expected_a_din ^ a_din ^ expected_a_din) &&
                expected_b_din === (expected_b_din ^ b_din ^ expected_b_din) &&
                expected_io_dout === (expected_io_dout ^ io_dout ^ expected_io_dout) &&
                expected_io_dout_en === (expected_io_dout_en ^ io_dout_en ^ expected_io_dout_en)) begin
                $display("PASS");
                $display("  Outputs: a_din=%h, b_din=%h, io_dout=%h, io_dout_en=%h",
                         a_din, b_din, io_dout, io_dout_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_din=%h, b_din=%h, io_dout=%h, io_dout_en=%h",
                         expected_a_din, expected_b_din, expected_io_dout, expected_io_dout_en);
                $display("  Got:      a_din=%h, b_din=%h, io_dout=%h, io_dout_en=%h",
                         a_din, b_din, io_dout, io_dout_en);
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
