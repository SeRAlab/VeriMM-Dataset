`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] e;
    reg reset;
    reg vgae;
    wire vgaw;
    wire [7:0] vgax;
    wire [7:0] vgay;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .e(e),
        .reset(reset),
        .vgae(vgae),
        .vgaw(vgaw),
        .vgax(vgax),
        .vgay(vgay)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Reset and Initialization", test_num);


        clk = 0;
        reset = 1;
        vgae = 0;
        e = 16'h0000;


        repeat(2) @(posedge clk);
        #1 reset = 0;


        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 8'h00, 8'h00);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Check inputs do not affect static outputs (Data Pattern 1)", test_num);

        reset = 1;
        vgae = 1;
        e = 16'hAAAA;

        repeat(2) @(posedge clk);
        #1 reset = 0;


        @(posedge clk);
        e = 16'h5555;
        vgae = 0;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b1, 8'h00, 8'h00);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Check inputs do not affect static outputs (Data Pattern 2)", test_num);

        reset = 1;
        vgae = 1;
        e = 16'hFFFF;

        repeat(2) @(posedge clk);
        #1 reset = 0;


        @(posedge clk); e = 16'h1234;
        @(posedge clk); e = 16'h8888;
        @(posedge clk); e = 16'h0000;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b1, 8'h00, 8'h00);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verification after extended clock cycles", test_num);

        reset = 1;
        vgae = 0;
        e = 16'h0;

        repeat(2) @(posedge clk);
        #1 reset = 0;


        repeat(50) @(posedge clk);

        #1;


        check_outputs(1'b1, 8'h00, 8'h00);
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
        input expected_vgaw;
        input [7:0] expected_vgax;
        input [7:0] expected_vgay;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vgaw === (expected_vgaw ^ vgaw ^ expected_vgaw) &&
                expected_vgax === (expected_vgax ^ vgax ^ expected_vgax) &&
                expected_vgay === (expected_vgay ^ vgay ^ expected_vgay)) begin
                $display("PASS");
                $display("  Outputs: vgaw=%b, vgax=%h, vgay=%h",
                         vgaw, vgax, vgay);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vgaw=%b, vgax=%h, vgay=%h",
                         expected_vgaw, expected_vgax, expected_vgay);
                $display("  Got:      vgaw=%b, vgax=%h, vgay=%h",
                         vgaw, vgax, vgay);
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
