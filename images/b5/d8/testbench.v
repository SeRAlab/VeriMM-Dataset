`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_6MB;
    reg CLK_SERVID;
    reg [6:0] VIDEO_B;
    reg [6:0] VIDEO_G;
    reg [6:0] VIDEO_R;
    reg nRESET;
    wire VIDEO_B_SER;
    wire VIDEO_CLK_SER;
    wire VIDEO_G_SER;
    wire VIDEO_LAT_SER;
    wire VIDEO_R_SER;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_6MB(CLK_6MB),
        .CLK_SERVID(CLK_SERVID),
        .VIDEO_B(VIDEO_B),
        .VIDEO_G(VIDEO_G),
        .VIDEO_R(VIDEO_R),
        .nRESET(nRESET),
        .VIDEO_B_SER(VIDEO_B_SER),
        .VIDEO_CLK_SER(VIDEO_CLK_SER),
        .VIDEO_G_SER(VIDEO_G_SER),
        .VIDEO_LAT_SER(VIDEO_LAT_SER),
        .VIDEO_R_SER(VIDEO_R_SER)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_SERVID = 0;
        forever #5 CLK_SERVID = ~CLK_SERVID;
    end

        task reset_dut;

    begin
        nRESET = 0;
        CLK_6MB = 0;
        VIDEO_R = 7'd0;
        VIDEO_G = 7'd0;
        VIDEO_B = 7'd0;
        #20;
        nRESET = 1;
        #20;
        @(posedge CLK_SERVID);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All 1s", test_num);
        reset_dut();


        VIDEO_R = 7'b1111111;
        VIDEO_G = 7'b1111111;
        VIDEO_B = 7'b1111111;


        @(posedge CLK_SERVID);
        CLK_6MB = 1;
        @(posedge CLK_SERVID);
        CLK_6MB = 0;




        repeat(6) @(posedge CLK_SERVID);
        #2;


        #1;



        check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All 0s", test_num);
        reset_dut();

        VIDEO_R = 7'b0000000;
        VIDEO_G = 7'b0000000;
        VIDEO_B = 7'b0000000;

        @(posedge CLK_SERVID);
        CLK_6MB = 1;
        @(posedge CLK_SERVID);
        CLK_6MB = 0;

        repeat(6) @(posedge CLK_SERVID);
        #2;


        #1;



        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating Bits", test_num);
        reset_dut();


        VIDEO_R = 7'b1010101;
        VIDEO_G = 7'b0101010;
        VIDEO_B = 7'b1111111;

        @(posedge CLK_SERVID);
        CLK_6MB = 1;
        @(posedge CLK_SERVID);
        CLK_6MB = 0;

        repeat(6) @(posedge CLK_SERVID);
        #2;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Unique Patterns", test_num);
        reset_dut();


        VIDEO_R = 7'b1111110;
        VIDEO_G = 7'b0000001;
        VIDEO_B = 7'b1010100;

        @(posedge CLK_SERVID);
        CLK_6MB = 1;
        @(posedge CLK_SERVID);
        CLK_6MB = 0;

        repeat(6) @(posedge CLK_SERVID);
        #2;


        #1;



        check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Mid-range Pattern", test_num);
        reset_dut();

        VIDEO_R = 7'h5A;
        VIDEO_G = 7'h3C;
        VIDEO_B = 7'h7F;

        @(posedge CLK_SERVID);
        CLK_6MB = 1;
        @(posedge CLK_SERVID);
        CLK_6MB = 0;

        repeat(6) @(posedge CLK_SERVID);
        #2;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_VIDEO_B_SER;
        input expected_VIDEO_CLK_SER;
        input expected_VIDEO_G_SER;
        input expected_VIDEO_LAT_SER;
        input expected_VIDEO_R_SER;
        begin
            if (expected_VIDEO_B_SER === (expected_VIDEO_B_SER ^ VIDEO_B_SER ^ expected_VIDEO_B_SER) &&
                expected_VIDEO_CLK_SER === (expected_VIDEO_CLK_SER ^ VIDEO_CLK_SER ^ expected_VIDEO_CLK_SER) &&
                expected_VIDEO_G_SER === (expected_VIDEO_G_SER ^ VIDEO_G_SER ^ expected_VIDEO_G_SER) &&
                expected_VIDEO_LAT_SER === (expected_VIDEO_LAT_SER ^ VIDEO_LAT_SER ^ expected_VIDEO_LAT_SER) &&
                expected_VIDEO_R_SER === (expected_VIDEO_R_SER ^ VIDEO_R_SER ^ expected_VIDEO_R_SER)) begin
                $display("PASS");
                $display("  Outputs: VIDEO_B_SER=%b, VIDEO_CLK_SER=%b, VIDEO_G_SER=%b, VIDEO_LAT_SER=%b, VIDEO_R_SER=%b",
                         VIDEO_B_SER, VIDEO_CLK_SER, VIDEO_G_SER, VIDEO_LAT_SER, VIDEO_R_SER);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VIDEO_B_SER=%b, VIDEO_CLK_SER=%b, VIDEO_G_SER=%b, VIDEO_LAT_SER=%b, VIDEO_R_SER=%b",
                         expected_VIDEO_B_SER, expected_VIDEO_CLK_SER, expected_VIDEO_G_SER, expected_VIDEO_LAT_SER, expected_VIDEO_R_SER);
                $display("  Got:      VIDEO_B_SER=%b, VIDEO_CLK_SER=%b, VIDEO_G_SER=%b, VIDEO_LAT_SER=%b, VIDEO_R_SER=%b",
                         VIDEO_B_SER, VIDEO_CLK_SER, VIDEO_G_SER, VIDEO_LAT_SER, VIDEO_R_SER);
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
        $dumpvars(0,CLK_6MB, CLK_SERVID, VIDEO_B, VIDEO_G, VIDEO_R, nRESET, VIDEO_B_SER, VIDEO_CLK_SER, VIDEO_G_SER, VIDEO_LAT_SER, VIDEO_R_SER);
    end

endmodule
