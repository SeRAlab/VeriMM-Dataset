`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] io_ins_0_bits_wdata_0;
    reg [31:0] io_ins_0_bits_wdata_1;
    reg [31:0] io_ins_0_bits_wdata_10;
    reg [31:0] io_ins_0_bits_wdata_11;
    reg [31:0] io_ins_0_bits_wdata_12;
    reg [31:0] io_ins_0_bits_wdata_13;
    reg [31:0] io_ins_0_bits_wdata_14;
    reg [31:0] io_ins_0_bits_wdata_15;
    reg [31:0] io_ins_0_bits_wdata_2;
    reg [31:0] io_ins_0_bits_wdata_3;
    reg [31:0] io_ins_0_bits_wdata_4;
    reg [31:0] io_ins_0_bits_wdata_5;
    reg [31:0] io_ins_0_bits_wdata_6;
    reg [31:0] io_ins_0_bits_wdata_7;
    reg [31:0] io_ins_0_bits_wdata_8;
    reg [31:0] io_ins_0_bits_wdata_9;
    reg io_ins_0_bits_wlast;
    reg io_ins_0_valid;
    wire [31:0] io_out_bits_wdata_0;
    wire [31:0] io_out_bits_wdata_1;
    wire [31:0] io_out_bits_wdata_10;
    wire [31:0] io_out_bits_wdata_11;
    wire [31:0] io_out_bits_wdata_12;
    wire [31:0] io_out_bits_wdata_13;
    wire [31:0] io_out_bits_wdata_14;
    wire [31:0] io_out_bits_wdata_15;
    wire [31:0] io_out_bits_wdata_2;
    wire [31:0] io_out_bits_wdata_3;
    wire [31:0] io_out_bits_wdata_4;
    wire [31:0] io_out_bits_wdata_5;
    wire [31:0] io_out_bits_wdata_6;
    wire [31:0] io_out_bits_wdata_7;
    wire [31:0] io_out_bits_wdata_8;
    wire [31:0] io_out_bits_wdata_9;
    wire io_out_bits_wlast;
    wire io_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_ins_0_bits_wdata_0(io_ins_0_bits_wdata_0),
        .io_ins_0_bits_wdata_1(io_ins_0_bits_wdata_1),
        .io_ins_0_bits_wdata_10(io_ins_0_bits_wdata_10),
        .io_ins_0_bits_wdata_11(io_ins_0_bits_wdata_11),
        .io_ins_0_bits_wdata_12(io_ins_0_bits_wdata_12),
        .io_ins_0_bits_wdata_13(io_ins_0_bits_wdata_13),
        .io_ins_0_bits_wdata_14(io_ins_0_bits_wdata_14),
        .io_ins_0_bits_wdata_15(io_ins_0_bits_wdata_15),
        .io_ins_0_bits_wdata_2(io_ins_0_bits_wdata_2),
        .io_ins_0_bits_wdata_3(io_ins_0_bits_wdata_3),
        .io_ins_0_bits_wdata_4(io_ins_0_bits_wdata_4),
        .io_ins_0_bits_wdata_5(io_ins_0_bits_wdata_5),
        .io_ins_0_bits_wdata_6(io_ins_0_bits_wdata_6),
        .io_ins_0_bits_wdata_7(io_ins_0_bits_wdata_7),
        .io_ins_0_bits_wdata_8(io_ins_0_bits_wdata_8),
        .io_ins_0_bits_wdata_9(io_ins_0_bits_wdata_9),
        .io_ins_0_bits_wlast(io_ins_0_bits_wlast),
        .io_ins_0_valid(io_ins_0_valid),
        .io_out_bits_wdata_0(io_out_bits_wdata_0),
        .io_out_bits_wdata_1(io_out_bits_wdata_1),
        .io_out_bits_wdata_10(io_out_bits_wdata_10),
        .io_out_bits_wdata_11(io_out_bits_wdata_11),
        .io_out_bits_wdata_12(io_out_bits_wdata_12),
        .io_out_bits_wdata_13(io_out_bits_wdata_13),
        .io_out_bits_wdata_14(io_out_bits_wdata_14),
        .io_out_bits_wdata_15(io_out_bits_wdata_15),
        .io_out_bits_wdata_2(io_out_bits_wdata_2),
        .io_out_bits_wdata_3(io_out_bits_wdata_3),
        .io_out_bits_wdata_4(io_out_bits_wdata_4),
        .io_out_bits_wdata_5(io_out_bits_wdata_5),
        .io_out_bits_wdata_6(io_out_bits_wdata_6),
        .io_out_bits_wdata_7(io_out_bits_wdata_7),
        .io_out_bits_wdata_8(io_out_bits_wdata_8),
        .io_out_bits_wdata_9(io_out_bits_wdata_9),
        .io_out_bits_wlast(io_out_bits_wlast),
        .io_out_valid(io_out_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            io_ins_0_valid = 1'b1;
            io_ins_0_bits_wlast = 1'b0;
            io_ins_0_bits_wdata_0 = 32'h0;
            io_ins_0_bits_wdata_1 = 32'h1;
            io_ins_0_bits_wdata_2 = 32'h2;
            io_ins_0_bits_wdata_3 = 32'h3;
            io_ins_0_bits_wdata_4 = 32'h4;
            io_ins_0_bits_wdata_5 = 32'h5;
            io_ins_0_bits_wdata_6 = 32'h6;
            io_ins_0_bits_wdata_7 = 32'h7;
            io_ins_0_bits_wdata_8 = 32'h8;
            io_ins_0_bits_wdata_9 = 32'h9;
            io_ins_0_bits_wdata_10 = 32'hA;
            io_ins_0_bits_wdata_11 = 32'hB;
            io_ins_0_bits_wdata_12 = 32'hC;
            io_ins_0_bits_wdata_13 = 32'hD;
            io_ins_0_bits_wdata_14 = 32'hE;
            io_ins_0_bits_wdata_15 = 32'hF;



            #1;




            check_outputs(32'h0, 32'h1, 32'hA, 32'hB, 32'hC, 32'hD, 32'hE, 32'hF,
                          32'h2, 32'h3, 32'h4, 32'h5, 32'h6, 32'h7, 32'h8, 32'h9,
                          1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            io_ins_0_valid = 1'b1;
            io_ins_0_bits_wlast = 1'b1;
            io_ins_0_bits_wdata_0 = 32'hDEADBEEF;
            io_ins_0_bits_wdata_1 = 32'hCAFEBABE;
            io_ins_0_bits_wdata_2 = 32'h00000002;
            io_ins_0_bits_wdata_3 = 32'h00000003;
            io_ins_0_bits_wdata_4 = 32'h00000004;
            io_ins_0_bits_wdata_5 = 32'h00000005;
            io_ins_0_bits_wdata_6 = 32'h00000006;
            io_ins_0_bits_wdata_7 = 32'h00000007;
            io_ins_0_bits_wdata_8 = 32'h00000008;
            io_ins_0_bits_wdata_9 = 32'h00000009;
            io_ins_0_bits_wdata_10 = 32'h00000010;
            io_ins_0_bits_wdata_11 = 32'h00000011;
            io_ins_0_bits_wdata_12 = 32'h00000012;
            io_ins_0_bits_wdata_13 = 32'h00000013;
            io_ins_0_bits_wdata_14 = 32'h00000014;
            io_ins_0_bits_wdata_15 = 32'h00000015;

            #1;


            check_outputs(32'hDEADBEEF, 32'hCAFEBABE, 32'h00000010, 32'h00000011, 32'h00000012, 32'h00000013, 32'h00000014, 32'h00000015,
                          32'h00000002, 32'h00000003, 32'h00000004, 32'h00000005, 32'h00000006, 32'h00000007, 32'h00000008, 32'h00000009,
                          1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            io_ins_0_valid = 1'b0;
            io_ins_0_bits_wlast = 1'b0;
            io_ins_0_bits_wdata_0 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_1 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_2 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_3 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_4 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_5 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_6 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_7 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_8 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_9 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_10 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_11 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_12 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_13 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_14 = 32'hFFFFFFFF;
            io_ins_0_bits_wdata_15 = 32'hFFFFFFFF;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF,
                          32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF,
                          1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            io_ins_0_valid = 1'b1;
            io_ins_0_bits_wlast = 1'b0;
            io_ins_0_bits_wdata_0 = 32'hAAAAAAAA;
            io_ins_0_bits_wdata_1 = 32'h55555555;
            io_ins_0_bits_wdata_2 = 32'hAAAAAAAA;
            io_ins_0_bits_wdata_3 = 32'h55555555;
            io_ins_0_bits_wdata_4 = 32'hAAAAAAAA;
            io_ins_0_bits_wdata_5 = 32'h55555555;
            io_ins_0_bits_wdata_6 = 32'hAAAAAAAA;
            io_ins_0_bits_wdata_7 = 32'h55555555;
            io_ins_0_bits_wdata_8 = 32'hAAAAAAAA;
            io_ins_0_bits_wdata_9 = 32'h55555555;
            io_ins_0_bits_wdata_10 = 32'hAAAAAAAA;
            io_ins_0_bits_wdata_11 = 32'h55555555;
            io_ins_0_bits_wdata_12 = 32'hAAAAAAAA;
            io_ins_0_bits_wdata_13 = 32'h55555555;
            io_ins_0_bits_wdata_14 = 32'hAAAAAAAA;
            io_ins_0_bits_wdata_15 = 32'h55555555;

            #1;


            check_outputs(32'hAAAAAAAA, 32'h55555555, 32'hAAAAAAAA, 32'h55555555, 32'hAAAAAAAA, 32'h55555555, 32'hAAAAAAAA, 32'h55555555,
                          32'hAAAAAAAA, 32'h55555555, 32'hAAAAAAAA, 32'h55555555, 32'hAAAAAAAA, 32'h55555555, 32'hAAAAAAAA, 32'h55555555,
                          1'b0, 1'b1);
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
        input [31:0] expected_io_out_bits_wdata_0;
        input [31:0] expected_io_out_bits_wdata_1;
        input [31:0] expected_io_out_bits_wdata_10;
        input [31:0] expected_io_out_bits_wdata_11;
        input [31:0] expected_io_out_bits_wdata_12;
        input [31:0] expected_io_out_bits_wdata_13;
        input [31:0] expected_io_out_bits_wdata_14;
        input [31:0] expected_io_out_bits_wdata_15;
        input [31:0] expected_io_out_bits_wdata_2;
        input [31:0] expected_io_out_bits_wdata_3;
        input [31:0] expected_io_out_bits_wdata_4;
        input [31:0] expected_io_out_bits_wdata_5;
        input [31:0] expected_io_out_bits_wdata_6;
        input [31:0] expected_io_out_bits_wdata_7;
        input [31:0] expected_io_out_bits_wdata_8;
        input [31:0] expected_io_out_bits_wdata_9;
        input expected_io_out_bits_wlast;
        input expected_io_out_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_out_bits_wdata_0 === (expected_io_out_bits_wdata_0 ^ io_out_bits_wdata_0 ^ expected_io_out_bits_wdata_0) &&
                expected_io_out_bits_wdata_1 === (expected_io_out_bits_wdata_1 ^ io_out_bits_wdata_1 ^ expected_io_out_bits_wdata_1) &&
                expected_io_out_bits_wdata_10 === (expected_io_out_bits_wdata_10 ^ io_out_bits_wdata_10 ^ expected_io_out_bits_wdata_10) &&
                expected_io_out_bits_wdata_11 === (expected_io_out_bits_wdata_11 ^ io_out_bits_wdata_11 ^ expected_io_out_bits_wdata_11) &&
                expected_io_out_bits_wdata_12 === (expected_io_out_bits_wdata_12 ^ io_out_bits_wdata_12 ^ expected_io_out_bits_wdata_12) &&
                expected_io_out_bits_wdata_13 === (expected_io_out_bits_wdata_13 ^ io_out_bits_wdata_13 ^ expected_io_out_bits_wdata_13) &&
                expected_io_out_bits_wdata_14 === (expected_io_out_bits_wdata_14 ^ io_out_bits_wdata_14 ^ expected_io_out_bits_wdata_14) &&
                expected_io_out_bits_wdata_15 === (expected_io_out_bits_wdata_15 ^ io_out_bits_wdata_15 ^ expected_io_out_bits_wdata_15) &&
                expected_io_out_bits_wdata_2 === (expected_io_out_bits_wdata_2 ^ io_out_bits_wdata_2 ^ expected_io_out_bits_wdata_2) &&
                expected_io_out_bits_wdata_3 === (expected_io_out_bits_wdata_3 ^ io_out_bits_wdata_3 ^ expected_io_out_bits_wdata_3) &&
                expected_io_out_bits_wdata_4 === (expected_io_out_bits_wdata_4 ^ io_out_bits_wdata_4 ^ expected_io_out_bits_wdata_4) &&
                expected_io_out_bits_wdata_5 === (expected_io_out_bits_wdata_5 ^ io_out_bits_wdata_5 ^ expected_io_out_bits_wdata_5) &&
                expected_io_out_bits_wdata_6 === (expected_io_out_bits_wdata_6 ^ io_out_bits_wdata_6 ^ expected_io_out_bits_wdata_6) &&
                expected_io_out_bits_wdata_7 === (expected_io_out_bits_wdata_7 ^ io_out_bits_wdata_7 ^ expected_io_out_bits_wdata_7) &&
                expected_io_out_bits_wdata_8 === (expected_io_out_bits_wdata_8 ^ io_out_bits_wdata_8 ^ expected_io_out_bits_wdata_8) &&
                expected_io_out_bits_wdata_9 === (expected_io_out_bits_wdata_9 ^ io_out_bits_wdata_9 ^ expected_io_out_bits_wdata_9) &&
                expected_io_out_bits_wlast === (expected_io_out_bits_wlast ^ io_out_bits_wlast ^ expected_io_out_bits_wlast) &&
                expected_io_out_valid === (expected_io_out_valid ^ io_out_valid ^ expected_io_out_valid)) begin
                $display("PASS");
                $display("  Outputs: io_out_bits_wdata_0=%h, io_out_bits_wdata_1=%h, io_out_bits_wdata_10=%h, io_out_bits_wdata_11=%h, io_out_bits_wdata_12=%h, io_out_bits_wdata_13=%h, io_out_bits_wdata_14=%h, io_out_bits_wdata_15=%h, io_out_bits_wdata_2=%h, io_out_bits_wdata_3=%h, io_out_bits_wdata_4=%h, io_out_bits_wdata_5=%h, io_out_bits_wdata_6=%h, io_out_bits_wdata_7=%h, io_out_bits_wdata_8=%h, io_out_bits_wdata_9=%h, io_out_bits_wlast=%b, io_out_valid=%b",
                         io_out_bits_wdata_0, io_out_bits_wdata_1, io_out_bits_wdata_10, io_out_bits_wdata_11, io_out_bits_wdata_12, io_out_bits_wdata_13, io_out_bits_wdata_14, io_out_bits_wdata_15, io_out_bits_wdata_2, io_out_bits_wdata_3, io_out_bits_wdata_4, io_out_bits_wdata_5, io_out_bits_wdata_6, io_out_bits_wdata_7, io_out_bits_wdata_8, io_out_bits_wdata_9, io_out_bits_wlast, io_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out_bits_wdata_0=%h, io_out_bits_wdata_1=%h, io_out_bits_wdata_10=%h, io_out_bits_wdata_11=%h, io_out_bits_wdata_12=%h, io_out_bits_wdata_13=%h, io_out_bits_wdata_14=%h, io_out_bits_wdata_15=%h, io_out_bits_wdata_2=%h, io_out_bits_wdata_3=%h, io_out_bits_wdata_4=%h, io_out_bits_wdata_5=%h, io_out_bits_wdata_6=%h, io_out_bits_wdata_7=%h, io_out_bits_wdata_8=%h, io_out_bits_wdata_9=%h, io_out_bits_wlast=%b, io_out_valid=%b",
                         expected_io_out_bits_wdata_0, expected_io_out_bits_wdata_1, expected_io_out_bits_wdata_10, expected_io_out_bits_wdata_11, expected_io_out_bits_wdata_12, expected_io_out_bits_wdata_13, expected_io_out_bits_wdata_14, expected_io_out_bits_wdata_15, expected_io_out_bits_wdata_2, expected_io_out_bits_wdata_3, expected_io_out_bits_wdata_4, expected_io_out_bits_wdata_5, expected_io_out_bits_wdata_6, expected_io_out_bits_wdata_7, expected_io_out_bits_wdata_8, expected_io_out_bits_wdata_9, expected_io_out_bits_wlast, expected_io_out_valid);
                $display("  Got:      io_out_bits_wdata_0=%h, io_out_bits_wdata_1=%h, io_out_bits_wdata_10=%h, io_out_bits_wdata_11=%h, io_out_bits_wdata_12=%h, io_out_bits_wdata_13=%h, io_out_bits_wdata_14=%h, io_out_bits_wdata_15=%h, io_out_bits_wdata_2=%h, io_out_bits_wdata_3=%h, io_out_bits_wdata_4=%h, io_out_bits_wdata_5=%h, io_out_bits_wdata_6=%h, io_out_bits_wdata_7=%h, io_out_bits_wdata_8=%h, io_out_bits_wdata_9=%h, io_out_bits_wlast=%b, io_out_valid=%b",
                         io_out_bits_wdata_0, io_out_bits_wdata_1, io_out_bits_wdata_10, io_out_bits_wdata_11, io_out_bits_wdata_12, io_out_bits_wdata_13, io_out_bits_wdata_14, io_out_bits_wdata_15, io_out_bits_wdata_2, io_out_bits_wdata_3, io_out_bits_wdata_4, io_out_bits_wdata_5, io_out_bits_wdata_6, io_out_bits_wdata_7, io_out_bits_wdata_8, io_out_bits_wdata_9, io_out_bits_wlast, io_out_valid);
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
