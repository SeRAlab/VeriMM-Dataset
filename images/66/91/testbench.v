`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [63:0] io_x_0;
    reg [63:0] io_x_1;
    reg [63:0] io_x_10;
    reg [63:0] io_x_11;
    reg [63:0] io_x_12;
    reg [63:0] io_x_13;
    reg [63:0] io_x_14;
    reg [63:0] io_x_15;
    reg [63:0] io_x_16;
    reg [63:0] io_x_17;
    reg [63:0] io_x_18;
    reg [63:0] io_x_19;
    reg [63:0] io_x_2;
    reg [63:0] io_x_20;
    reg [63:0] io_x_21;
    reg [63:0] io_x_22;
    reg [63:0] io_x_23;
    reg [63:0] io_x_24;
    reg [63:0] io_x_25;
    reg [63:0] io_x_26;
    reg [63:0] io_x_27;
    reg [63:0] io_x_28;
    reg [63:0] io_x_29;
    reg [63:0] io_x_3;
    reg [63:0] io_x_30;
    reg [63:0] io_x_31;
    reg [63:0] io_x_32;
    reg [63:0] io_x_33;
    reg [63:0] io_x_4;
    reg [63:0] io_x_5;
    reg [63:0] io_x_6;
    reg [63:0] io_x_7;
    reg [63:0] io_x_8;
    reg [63:0] io_x_9;
    reg reset;
    wire [63:0] io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_x_0(io_x_0),
        .io_x_1(io_x_1),
        .io_x_10(io_x_10),
        .io_x_11(io_x_11),
        .io_x_12(io_x_12),
        .io_x_13(io_x_13),
        .io_x_14(io_x_14),
        .io_x_15(io_x_15),
        .io_x_16(io_x_16),
        .io_x_17(io_x_17),
        .io_x_18(io_x_18),
        .io_x_19(io_x_19),
        .io_x_2(io_x_2),
        .io_x_20(io_x_20),
        .io_x_21(io_x_21),
        .io_x_22(io_x_22),
        .io_x_23(io_x_23),
        .io_x_24(io_x_24),
        .io_x_25(io_x_25),
        .io_x_26(io_x_26),
        .io_x_27(io_x_27),
        .io_x_28(io_x_28),
        .io_x_29(io_x_29),
        .io_x_3(io_x_3),
        .io_x_30(io_x_30),
        .io_x_31(io_x_31),
        .io_x_32(io_x_32),
        .io_x_33(io_x_33),
        .io_x_4(io_x_4),
        .io_x_5(io_x_5),
        .io_x_6(io_x_6),
        .io_x_7(io_x_7),
        .io_x_8(io_x_8),
        .io_x_9(io_x_9),
        .reset(reset),
        .io_out(io_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs set to 0", test_num);


        reset = 1;
        clock = 0;
        #10 clock = 1; #10 clock = 0;
        reset = 0;


        io_x_0 = 64'h0; io_x_1 = 64'h0; io_x_2 = 64'h0; io_x_3 = 64'h0;
        io_x_4 = 64'h0; io_x_5 = 64'h0; io_x_6 = 64'h0; io_x_7 = 64'h0;
        io_x_8 = 64'h0; io_x_9 = 64'h0; io_x_10 = 64'h0; io_x_11 = 64'h0;
        io_x_12 = 64'h0; io_x_13 = 64'h0; io_x_14 = 64'h0; io_x_15 = 64'h0;
        io_x_16 = 64'h0; io_x_17 = 64'h0; io_x_18 = 64'h0; io_x_19 = 64'h0;
        io_x_20 = 64'h0; io_x_21 = 64'h0; io_x_22 = 64'h0; io_x_23 = 64'h0;
        io_x_24 = 64'h0; io_x_25 = 64'h0; io_x_26 = 64'h0; io_x_27 = 64'h0;
        io_x_28 = 64'h0; io_x_29 = 64'h0; io_x_30 = 64'h0; io_x_31 = 64'h0;
        io_x_32 = 64'h0; io_x_33 = 64'h0;

        #10 clock = 1; #10 clock = 0;


        #1;



        check_outputs(64'h6700000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs set to Maximum (All 1s)", test_num);


        reset = 1;
        #10 clock = 1; #10 clock = 0;
        reset = 0;


        io_x_0 = 64'hFFFFFFFFFFFFFFFF; io_x_1 = 64'hFFFFFFFFFFFFFFFF;
        io_x_2 = 64'hFFFFFFFFFFFFFFFF; io_x_3 = 64'hFFFFFFFFFFFFFFFF;
        io_x_4 = 64'hFFFFFFFFFFFFFFFF; io_x_5 = 64'hFFFFFFFFFFFFFFFF;
        io_x_6 = 64'hFFFFFFFFFFFFFFFF; io_x_7 = 64'hFFFFFFFFFFFFFFFF;
        io_x_8 = 64'hFFFFFFFFFFFFFFFF; io_x_9 = 64'hFFFFFFFFFFFFFFFF;
        io_x_10 = 64'hFFFFFFFFFFFFFFFF; io_x_11 = 64'hFFFFFFFFFFFFFFFF;
        io_x_12 = 64'hFFFFFFFFFFFFFFFF; io_x_13 = 64'hFFFFFFFFFFFFFFFF;
        io_x_14 = 64'hFFFFFFFFFFFFFFFF; io_x_15 = 64'hFFFFFFFFFFFFFFFF;
        io_x_16 = 64'hFFFFFFFFFFFFFFFF; io_x_17 = 64'hFFFFFFFFFFFFFFFF;
        io_x_18 = 64'hFFFFFFFFFFFFFFFF; io_x_19 = 64'hFFFFFFFFFFFFFFFF;
        io_x_20 = 64'hFFFFFFFFFFFFFFFF; io_x_21 = 64'hFFFFFFFFFFFFFFFF;
        io_x_22 = 64'hFFFFFFFFFFFFFFFF; io_x_23 = 64'hFFFFFFFFFFFFFFFF;
        io_x_24 = 64'hFFFFFFFFFFFFFFFF; io_x_25 = 64'hFFFFFFFFFFFFFFFF;
        io_x_26 = 64'hFFFFFFFFFFFFFFFF; io_x_27 = 64'hFFFFFFFFFFFFFFFF;
        io_x_28 = 64'hFFFFFFFFFFFFFFFF; io_x_29 = 64'hFFFFFFFFFFFFFFFF;
        io_x_30 = 64'hFFFFFFFFFFFFFFFF; io_x_31 = 64'hFFFFFFFFFFFFFFFF;
        io_x_32 = 64'hFFFFFFFFFFFFFFFF; io_x_33 = 64'hFFFFFFFFFFFFFFFF;

        #10 clock = 1; #10 clock = 0;


        #1;



        check_outputs(64'h6700000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Patterned inputs (0x55/0xAA)", test_num);


        reset = 1;
        #10 clock = 1; #10 clock = 0;
        reset = 0;


        io_x_0 = 64'h5555555555555555; io_x_1 = 64'hAAAAAAAAAAAAAAAA;
        io_x_2 = 64'h5555555555555555; io_x_3 = 64'hAAAAAAAAAAAAAAAA;
        io_x_4 = 64'h5555555555555555; io_x_5 = 64'hAAAAAAAAAAAAAAAA;
        io_x_6 = 64'h5555555555555555; io_x_7 = 64'hAAAAAAAAAAAAAAAA;
        io_x_8 = 64'h5555555555555555; io_x_9 = 64'hAAAAAAAAAAAAAAAA;
        io_x_10 = 64'h5555555555555555; io_x_11 = 64'hAAAAAAAAAAAAAAAA;
        io_x_12 = 64'h5555555555555555; io_x_13 = 64'hAAAAAAAAAAAAAAAA;
        io_x_14 = 64'h5555555555555555; io_x_15 = 64'hAAAAAAAAAAAAAAAA;
        io_x_16 = 64'h5555555555555555; io_x_17 = 64'hAAAAAAAAAAAAAAAA;
        io_x_18 = 64'h5555555555555555; io_x_19 = 64'hAAAAAAAAAAAAAAAA;
        io_x_20 = 64'h5555555555555555; io_x_21 = 64'hAAAAAAAAAAAAAAAA;
        io_x_22 = 64'h5555555555555555; io_x_23 = 64'hAAAAAAAAAAAAAAAA;
        io_x_24 = 64'h5555555555555555; io_x_25 = 64'hAAAAAAAAAAAAAAAA;
        io_x_26 = 64'h5555555555555555; io_x_27 = 64'hAAAAAAAAAAAAAAAA;
        io_x_28 = 64'h5555555555555555; io_x_29 = 64'hAAAAAAAAAAAAAAAA;
        io_x_30 = 64'h5555555555555555; io_x_31 = 64'hAAAAAAAAAAAAAAAA;
        io_x_32 = 64'h5555555555555555; io_x_33 = 64'hAAAAAAAAAAAAAAAA;

        #10 clock = 1; #10 clock = 0;


        #1;



        check_outputs(64'h6700000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random-style inputs", test_num);


        reset = 1;
        #10 clock = 1; #10 clock = 0;
        reset = 0;


        io_x_0 = 64'hDEADBEEFCAFEBABE;
        io_x_17 = 64'h1234567890ABCDEF;
        io_x_33 = 64'hFEDCBA0987654321;

        #10 clock = 1; #10 clock = 0;


        #1;



        check_outputs(64'h6700000000);
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
        input [63:0] expected_io_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_out=%h",
                         io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out=%h",
                         expected_io_out);
                $display("  Got:      io_out=%h",
                         io_out);
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
