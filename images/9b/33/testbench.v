`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] ADDRB;
    reg E;
    reg ENB;
    reg clk;
    reg [93:0] din;
    wire [5:0] ADDRA;
    wire [93:0] DOUTB;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDRB(ADDRB),
        .E(E),
        .ENB(ENB),
        .clk(clk),
        .din(din),
        .ADDRA(ADDRA),
        .DOUTB(DOUTB),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ENB = 0;
            E = 0;
            din = 0;
            ADDRB = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Write and Read", test_num);
            reset_dut();


            din = 94'h1234567890ABCDEF12345678;
            ADDRB = 6'd0;
            ENB = 1;
            @(posedge clk); #1;
            ENB = 0;


            E = 1;
            @(posedge clk); #1;
            E = 0;


            #1;



            check_outputs(6'd1, 94'h1234567890ABCDEF12345678, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Fill and Single Read", test_num);
            reset_dut();


            din = 94'hAAAAA; ADDRB = 6'd0; ENB = 1; @(posedge clk); #1;
            din = 94'hBBBBB; ADDRB = 6'd1; ENB = 1; @(posedge clk); #1;
            din = 94'hCCCCC; ADDRB = 6'd2; ENB = 1; @(posedge clk); #1;
            ENB = 0;


            E = 1;
            @(posedge clk); #1;
            E = 0;


            #1;



            check_outputs(6'd1, 94'hAAAAA, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill Entirely", test_num);
            reset_dut();


            for (i = 0; i < 64; i = i + 1) begin
                din = 94'hF00D + i;
                ADDRB = i[5:0];
                ENB = 1;
                @(posedge clk); #1;
            end
            ENB = 0;


            #1;



            check_outputs(6'd0, 94'd0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill and Empty Entirely", test_num);
            reset_dut();


            for (i = 0; i < 64; i = i + 1) begin
                din = 94'hD00 + i;
                ADDRB = i[5:0];
                ENB = 1;
                @(posedge clk); #1;
            end
            ENB = 0;


            for (i = 0; i < 64; i = i + 1) begin
                E = 1;
                @(posedge clk); #1;
            end
            E = 0;



            #1;




            check_outputs(6'd0, 94'hD00 + 63, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            din = 94'h1; ADDRB = 0; ENB = 1; @(posedge clk); #1;


            din = 94'h2; ADDRB = 1; ENB = 1; E = 1; @(posedge clk); #1;
            ENB = 0; E = 0;


            #1;



            check_outputs(6'd1, 94'h1, 1'b1);
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
        input [5:0] expected_ADDRA;
        input [93:0] expected_DOUTB;
        input expected_Q;
        begin
            if (expected_ADDRA === (expected_ADDRA ^ ADDRA ^ expected_ADDRA) &&
                expected_DOUTB === (expected_DOUTB ^ DOUTB ^ expected_DOUTB) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: ADDRA=%h, DOUTB=%h, Q=%b",
                         ADDRA, DOUTB, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ADDRA=%h, DOUTB=%h, Q=%b",
                         expected_ADDRA, expected_DOUTB, expected_Q);
                $display("  Got:      ADDRA=%h, DOUTB=%h, Q=%b",
                         ADDRA, DOUTB, Q);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ADDRB, E, ENB, clk, din, ADDRA, DOUTB, Q);
    end

endmodule
