`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] m;
    reg [7:0] n;
    reg [7:0] p;
    reg sel;
    wire [15:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .n(n),
        .p(p),
        .sel(sel),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;
        m = 8'd10; n = 8'd20; p = 8'd5; sel = 1'b0;
        $display("Test %0d: sel=0 (m+n-p) -> 10+20-5", test_num);
        #1;

        check_outputs(16'd25);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        m = 8'd255; n = 8'd255; p = 8'd10; sel = 1'b0;
        $display("Test %0d: sel=0 (m+n-p) -> 255+255-10", test_num);
        #1;

        check_outputs(16'd500);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        m = 8'd100; n = 8'd50; p = 8'd150; sel = 1'b0;
        $display("Test %0d: sel=0 (m+n-p) -> 100+50-150", test_num);
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        m = 8'd2; n = 8'd3; p = 8'd4; sel = 1'b1;
        $display("Test %0d: sel=1 (m*n+p) -> 2*3+4", test_num);
        #1;

        check_outputs(16'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        m = 8'd255; n = 8'd255; p = 8'd255; sel = 1'b1;
        $display("Test %0d: sel=1 (m*n+p) -> 255*255+255", test_num);
        #1;

        check_outputs(16'd65280);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        m = 8'd0; n = 8'd255; p = 8'd123; sel = 1'b1;
        $display("Test %0d: sel=1 (m*n+p) -> 0*255+123", test_num);
        #1;

        check_outputs(16'd123);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        m = 8'd128; n = 8'd2; p = 8'd0; sel = 1'b1;
        $display("Test %0d: sel=1 (m*n+p) -> 128*2+0", test_num);
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        m = 8'd1; n = 8'd1; p = 8'd1; sel = 1'b0;
        $display("Test %0d: sel=0 (m+n-p) -> 1+1-1", test_num);
        #1;

        check_outputs(16'd1);
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
        input [15:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
