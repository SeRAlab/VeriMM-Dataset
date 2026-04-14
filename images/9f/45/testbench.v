`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [3:0] in;
    reg [2:0] sel;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .in(in),
        .sel(sel),
        .q(q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=0, data0=5, in=4'b1000", test_num);
        sel = 3'd0;
        data0 = 4'h5;
        in = 4'b1000;
        #10;
        #1;

        check_outputs(8'h35);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=1, data1=A, in=4'b0110", test_num);
        sel = 3'd1;
        data1 = 4'hA;
        in = 4'b0110;
        #10;
        #1;

        check_outputs(8'h2A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=2, data2=3, in=4'b0011", test_num);
        sel = 3'd2;
        data2 = 4'h3;
        in = 4'b0011;
        #10;
        #1;

        check_outputs(8'h13);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=3, data3=F, in=4'b0001", test_num);
        sel = 3'd3;
        data3 = 4'hF;
        in = 4'b0001;
        #10;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=4, data4=8, in=4'b1111", test_num);
        sel = 3'd4;
        data4 = 4'h8;
        in = 4'b1111;
        #10;
        #1;

        check_outputs(8'h38);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=5, data5=2, in=4'b0000", test_num);
        sel = 3'd5;
        data5 = 4'h2;
        in = 4'b0000;
        #10;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=0, data0=C, in=4'b0101", test_num);
        sel = 3'd0;
        data0 = 4'hC;
        in = 4'b0101;
        #10;
        #1;

        check_outputs(8'h2C);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=5, data5=7, in=4'b1010", test_num);
        sel = 3'd5;
        data5 = 4'h7;
        in = 4'b1010;
        #10;
        #1;

        check_outputs(8'h37);
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
