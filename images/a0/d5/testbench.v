`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] probe0;
    reg [63:0] probe1;
    reg probe10;
    reg probe11;
    reg [63:0] probe12;
    reg probe13;
    reg probe14;
    reg probe15;
    reg probe16;
    reg probe17;
    reg [7:0] probe18;
    reg [8:0] probe19;
    reg probe2;
    reg probe20;
    reg [2:0] probe21;
    reg [2:0] probe22;
    reg probe23;
    reg [7:0] probe24;
    reg probe3;
    reg probe4;
    reg probe5;
    reg probe6;
    reg [63:0] probe7;
    reg probe8;
    reg probe9;
    wire [63:0] output0;
    wire output1;
    wire [63:0] output2;
    wire [7:0] output3;
    wire [8:0] output4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .probe0(probe0),
        .probe1(probe1),
        .probe10(probe10),
        .probe11(probe11),
        .probe12(probe12),
        .probe13(probe13),
        .probe14(probe14),
        .probe15(probe15),
        .probe16(probe16),
        .probe17(probe17),
        .probe18(probe18),
        .probe19(probe19),
        .probe2(probe2),
        .probe20(probe20),
        .probe21(probe21),
        .probe22(probe22),
        .probe23(probe23),
        .probe24(probe24),
        .probe3(probe3),
        .probe4(probe4),
        .probe5(probe5),
        .probe6(probe6),
        .probe7(probe7),
        .probe8(probe8),
        .probe9(probe9),
        .output0(output0),
        .output1(output1),
        .output2(output2),
        .output3(output3),
        .output4(output4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            probe0 = 0; probe1 = 0; probe2 = 0; probe3 = 0; probe4 = 0;
            probe5 = 0; probe6 = 0; probe7 = 0; probe8 = 0; probe9 = 0;
            probe10 = 0; probe11 = 0; probe12 = 0; probe13 = 0; probe14 = 0;
            probe15 = 0; probe16 = 0; probe17 = 0; probe18 = 0; probe19 = 0;
            probe20 = 0; probe21 = 0; probe22 = 0; probe23 = 0; probe24 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Zeros Verification", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0, 1'b0, 64'h0, 8'h0, 9'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: output1 Logical AND Verification", test_num);
            reset_dut();


            probe2 = 1; probe3 = 1; probe4 = 1; probe5 = 1; probe6 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0, 1'b1, 64'h0, 8'h0, 9'h0);


            probe4 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0, 1'b0, 64'h0, 8'h0, 9'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: 64-bit Concatenation (output0, output2)", test_num);
            reset_dut();

            probe0 = 64'hAAAA_AAAA_BBBB_BBBB;
            probe1 = 64'hCCCC_CCCC_DDDD_DDDD;
            probe7 = 64'h1111_1111_2222_2222;
            probe12 = 64'h3333_3333_4444_4444;

            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hBBBB_BBBB_DDDD_DDDD, 1'b0, 64'h2222_2222_4444_4444, 8'h0, 9'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Bit Merging Verification (output3, output4)", test_num);
            reset_dut();

            probe18 = 8'hA5;
            probe24 = 8'h3C;
            probe19 = 9'h1A7;
            probe21 = 3'b101;
            probe22 = 3'b010;

            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h0, 1'b0, 64'h0, 8'h5C, 9'h1EA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Boundary Values (All Ones)", test_num);
            reset_dut();

            probe0 = 64'hFFFF_FFFF_FFFF_FFFF;
            probe1 = 64'hFFFF_FFFF_FFFF_FFFF;
            probe2 = 1; probe3 = 1; probe4 = 1; probe5 = 1; probe6 = 1;
            probe7 = 64'hFFFF_FFFF_FFFF_FFFF;
            probe12 = 64'hFFFF_FFFF_FFFF_FFFF;
            probe18 = 8'hFF;
            probe19 = 9'h1FF;
            probe21 = 3'h7;
            probe22 = 3'h7;
            probe24 = 8'hFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b1, 64'hFFFF_FFFF_FFFF_FFFF, 8'hFF, 9'h1FF);
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
        input [63:0] expected_output0;
        input expected_output1;
        input [63:0] expected_output2;
        input [7:0] expected_output3;
        input [8:0] expected_output4;
        begin
            if (expected_output0 === (expected_output0 ^ output0 ^ expected_output0) &&
                expected_output1 === (expected_output1 ^ output1 ^ expected_output1) &&
                expected_output2 === (expected_output2 ^ output2 ^ expected_output2) &&
                expected_output3 === (expected_output3 ^ output3 ^ expected_output3) &&
                expected_output4 === (expected_output4 ^ output4 ^ expected_output4)) begin
                $display("PASS");
                $display("  Outputs: output0=%h, output1=%b, output2=%h, output3=%h, output4=%h",
                         output0, output1, output2, output3, output4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output0=%h, output1=%b, output2=%h, output3=%h, output4=%h",
                         expected_output0, expected_output1, expected_output2, expected_output3, expected_output4);
                $display("  Got:      output0=%h, output1=%b, output2=%h, output3=%h, output4=%h",
                         output0, output1, output2, output3, output4);
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
        $dumpvars(0,clk, probe0, probe1, probe10, probe11, probe12, probe13, probe14, probe15, probe16, probe17, probe18, probe19, probe2, probe20, probe21, probe22, probe23, probe24, probe3, probe4, probe5, probe6, probe7, probe8, probe9, output0, output1, output2, output3, output4);
    end

endmodule
