`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in0;
    reg [15:0] in1;
    reg [15:0] in2;
    reg [15:0] in3;
    reg [1:0] sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in0 = 16'hAAAA;
        in1 = 16'h5555;
        in2 = 16'hF0F0;
        in3 = 16'h0F0F;
        sel = 2'b00;
        $display("Test %0d: Selecting in0 (sel=00)", test_num);
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in0 = 16'hAAAA;
        in1 = 16'h5555;
        in2 = 16'hF0F0;
        in3 = 16'h0F0F;
        sel = 2'b01;
        $display("Test %0d: Selecting in1 (sel=01)", test_num);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in0 = 16'hAAAA;
        in1 = 16'h5555;
        in2 = 16'hF0F0;
        in3 = 16'h0F0F;
        sel = 2'b10;
        $display("Test %0d: Selecting in2 (sel=10)", test_num);
        #1;

        check_outputs(16'hF0F0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in0 = 16'hAAAA;
        in1 = 16'h5555;
        in2 = 16'hF0F0;
        in3 = 16'h0F0F;
        sel = 2'b11;
        $display("Test %0d: Selecting in3 (sel=11)", test_num);
        #1;

        check_outputs(16'h0F0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in0 = 16'h1234;
        in1 = 16'h5678;
        in2 = 16'h9ABC;
        in3 = 16'hDEF0;
        sel = 2'b10;
        $display("Test %0d: Change input data while selected (sel=10)", test_num);
        in2 = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in0 = 16'h0001;
        in1 = 16'h0002;
        in2 = 16'h0004;
        in3 = 16'h0008;
        sel = 2'b00;
        $display("Test %0d: Change select signal sequentially", test_num);
        sel = 2'b00; #2;
        sel = 2'b01; #2;
        sel = 2'b10; #2;
        sel = 2'b11;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in0 = 16'hFFFF;
        in1 = 16'hFFFF;
        in2 = 16'hFFFF;
        in3 = 16'hFFFF;
        sel = 2'b01;
        $display("Test %0d: All inputs same (All Ones)", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in0 = 16'h0000;
        in1 = 16'h0000;
        in2 = 16'h0000;
        in3 = 16'h0000;
        sel = 2'b11;
        $display("Test %0d: All inputs same (All Zeros)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
