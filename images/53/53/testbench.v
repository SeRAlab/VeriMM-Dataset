`timescale 1ns/1ps

module mux2to1_param_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_param dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in0 (Mixed Bits)", test_num);
        in0 = 8'hA5;
        in1 = 8'h5A;
        sel = 1'b0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in1 (Mixed Bits)", test_num);
        in0 = 8'hA5;
        in1 = 8'h5A;
        sel = 1'b1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in0 (All Zeros)", test_num);
        in0 = 8'h00;
        in1 = 8'hFF;
        sel = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in1 (All Zeros)", test_num);
        in0 = 8'hFF;
        in1 = 8'h00;
        sel = 1'b1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in0 (All Ones)", test_num);
        in0 = 8'hFF;
        in1 = 8'h00;
        sel = 1'b0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in1 (All Ones)", test_num);
        in0 = 8'h00;
        in1 = 8'hFF;
        sel = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input transition with sel constant (in0 selected)", test_num);
        sel = 1'b0;
        in1 = 8'h00;
        in0 = 8'h12;
        #5;
        in0 = 8'h34;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input transition with sel constant (in1 selected)", test_num);
        sel = 1'b1;
        in0 = 8'h00;
        in1 = 8'h56;
        #5;
        in1 = 8'h78;
        #1;

        check_outputs(8'h78);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit pattern test", test_num);
        in0 = 8'hAA;
        in1 = 8'h55;
        sel = 1'b0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit high test", test_num);
        in0 = 8'h00;
        in1 = 8'h01;
        sel = 1'b1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1_param Testbench");
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
        input [7:0] expected_out;
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
