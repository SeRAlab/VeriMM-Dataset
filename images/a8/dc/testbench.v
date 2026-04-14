`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [15:0] e;
    reg [15:0] f;
    reg [15:0] g;
    reg [15:0] h;
    reg [2:0] sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select Input A", test_num);
            a = 16'h1111; b = 16'h2222; c = 16'h3333; d = 16'h4444;
            e = 16'h5555; f = 16'h6666; g = 16'h7777; h = 16'h8888;
            sel = 3'b000;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select Input B", test_num);
            a = 16'hAAAA; b = 16'hBBBB; c = 16'hCCCC; d = 16'hDDDD;
            e = 16'hEEEE; f = 16'hFFFF; g = 16'h0000; h = 16'h1234;
            sel = 3'b001;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select Input C", test_num);
            a = 16'h1234; b = 16'h5678; c = 16'h9ABC; d = 16'hDEF0;
            e = 16'h0001; f = 16'h0002; g = 16'h0003; h = 16'h0004;
            sel = 3'b010;
            #1;

            check_outputs(16'h9ABC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select Input D", test_num);
            a = 16'h0; b = 16'h0; c = 16'h0; d = 16'hFFFF;
            e = 16'h0; f = 16'h0; g = 16'h0; h = 16'h0;
            sel = 3'b011;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select Input E", test_num);
            a = 16'hF0F0; b = 16'h0F0F; c = 16'hAAAA; d = 16'h5555;
            e = 16'h1234; f = 16'h0000; g = 16'hFFFF; h = 16'h8000;
            sel = 3'b100;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select Input F", test_num);
            a = 16'h1; b = 16'h2; c = 16'h3; d = 16'h4;
            e = 16'h5; f = 16'hC0DE; g = 16'h7; h = 16'h8;
            sel = 3'b101;
            #1;

            check_outputs(16'hC0DE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select Input G", test_num);
            a = 16'h1000; b = 16'h2000; c = 16'h3000; d = 16'h4000;
            e = 16'h5000; f = 16'h6000; g = 16'hBEEF; h = 16'h8000;
            sel = 3'b110;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select Input H", test_num);
            a = 16'h0001; b = 16'h0002; c = 16'h0004; d = 16'h0008;
            e = 16'h0010; f = 16'h0020; g = 16'h0040; h = 16'h0080;
            sel = 3'b111;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: All Inputs Zero, Select E", test_num);
            a = 16'h0; b = 16'h0; c = 16'h0; d = 16'h0;
            e = 16'h0; f = 16'h0; g = 16'h0; h = 16'h0;
            sel = 3'b100;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: All Inputs Max, Select G", test_num);
            a = 16'hFFFF; b = 16'hFFFF; c = 16'hFFFF; d = 16'hFFFF;
            e = 16'hFFFF; f = 16'hFFFF; g = 16'hFFFF; h = 16'hFFFF;
            sel = 3'b110;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
