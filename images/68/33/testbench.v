`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] din;
    reg reset;
    reg [2:0] sp;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .sp(sp),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset Check", test_num);


        clk = 0;
        reset = 1;
        din = 16'hFFFF;
        sp = 3'd4;
        #10;


        clk = 1; #10;
        clk = 0; #10;

        reset = 0;
        #10;


        #1;



        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write and Read from SP 0", test_num);

        reset = 1; #10; reset = 0; #10;


        din = 16'hABCD;
        sp = 3'd0;
        clk = 0; #5;
        clk = 1;
        #10;
        clk = 0;
        #5;

        #1;


        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write and Read from SP 7", test_num);

        reset = 1; #10; reset = 0; #10;


        din = 16'h55AA;
        sp = 3'd7;
        clk = 0; #5;
        clk = 1; #10;
        clk = 0; #5;

        #1;


        check_outputs(16'h55AA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Persistence check (Write SP 2, then SP 5, then read SP 2)", test_num);

        reset = 1; #10; reset = 0; #10;


        sp = 3'd2; din = 16'h1111;
        clk = 0; #5; clk = 1; #10; clk = 0; #5;


        sp = 3'd5; din = 16'h2222;
        clk = 0; #5; clk = 1; #10; clk = 0; #5;


        sp = 3'd2;
        din = 16'h1111;
        clk = 0; #5;
        clk = 1; #10;
        clk = 0;
        #5;

        #1;


        check_outputs(16'h1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset mid-operation", test_num);

        reset = 1; #10; reset = 0; #10;


        sp = 3'd3; din = 16'h9999;
        clk = 0; #5; clk = 1; #10; clk = 0; #5;


        reset = 1;
        #10;
        clk = 1; #10; clk = 0; #10;
        reset = 0;


        sp = 3'd3;
        clk = 0; #5;
        clk = 1; #10;
        clk = 0; #5;

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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
