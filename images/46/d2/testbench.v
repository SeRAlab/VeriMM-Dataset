`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg reset;
    reg [1:0] select;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .reset(reset),
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting in0", test_num);
        reset = 1;
        #10 reset = 0;
        select = 2'b00;
        in0 = 32'hAAAA_BBBB;
        in1 = 32'h1111_2222;
        in2 = 32'h3333_4444;
        in3 = 32'h5555_6666;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting in1", test_num);
        reset = 1;
        #10 reset = 0;
        select = 2'b01;
        in0 = 32'hAAAA_BBBB;
        in1 = 32'h1111_2222;
        in2 = 32'h3333_4444;
        in3 = 32'h5555_6666;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h1111_2222);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting in2", test_num);
        reset = 1;
        #10 reset = 0;
        select = 2'b10;
        in0 = 32'hAAAA_BBBB;
        in1 = 32'h1111_2222;
        in2 = 32'h3333_4444;
        in3 = 32'h5555_6666;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h3333_4444);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting in3", test_num);
        reset = 1;
        #10 reset = 0;
        select = 2'b11;
        in0 = 32'hAAAA_BBBB;
        in1 = 32'h1111_2222;
        in2 = 32'h3333_4444;
        in3 = 32'h5555_6666;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h5555_6666);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking Reset Priority", test_num);
        reset = 1;
        select = 2'b00;
        in0 = 32'hFFFF_FFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid Select (High Impedance)", test_num);
        reset = 1;
        #10 reset = 0;
        select = 2'bzz;
        in0 = 32'h1234_5678;
        @(posedge clk);
        #2;




        #1;





        check_outputs(32'hzzzz_zzzz);
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
        input [31:0] expected_out;
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
