`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [3:0] RA_A;
    reg [3:0] RA_B;
    reg [3:0] RA_C;
    reg [3:0] WA_A;
    reg WEN_A;
    reg [31:0] W_DA;
    wire [31:0] GRF_X;
    wire [31:0] GRF_Y;
    wire [31:0] GRF_Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RA_A(RA_A),
        .RA_B(RA_B),
        .RA_C(RA_C),
        .WA_A(WA_A),
        .WEN_A(WEN_A),
        .W_DA(W_DA),
        .GRF_X(GRF_X),
        .GRF_Y(GRF_Y),
        .GRF_Z(GRF_Z)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Write and Triple Read", test_num);


        WEN_A = 1;
        WA_A = 4'd1;
        W_DA = 32'hAAAAAAAA;
        @(posedge CLK);
        #1;
        WEN_A = 0;


        RA_A = 4'd1;
        RA_B = 4'd1;
        RA_C = 4'd1;

        #1;


        check_outputs(32'hAAAAAAAA, 32'hAAAAAAAA, 32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Multiple Register Writes and Independent Reads", test_num);


        WEN_A = 1; WA_A = 4'd2; W_DA = 32'h11112222;
        @(posedge CLK); #1;

        WEN_A = 1; WA_A = 4'd5; W_DA = 32'h55556666;
        @(posedge CLK); #1;

        WEN_A = 1; WA_A = 4'd10; W_DA = 32'hAAAAFFFF;
        @(posedge CLK); #1;
        WEN_A = 0;


        RA_A = 4'd2;
        RA_B = 4'd5;
        RA_C = 4'd10;

        #1;


        check_outputs(32'h11112222, 32'h55556666, 32'hAAAAFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Write Enable Disable Check", test_num);


        WEN_A = 1; WA_A = 4'd3; W_DA = 32'h00001234;
        @(posedge CLK); #1;


        WEN_A = 0; WA_A = 4'd3; W_DA = 32'hFFFFFFFF;
        @(posedge CLK); #1;


        RA_A = 4'd3; RA_B = 4'd3; RA_C = 4'd3;
        #1;

        check_outputs(32'h00001234, 32'h00001234, 32'h00001234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Overwriting Data", test_num);


        WEN_A = 1; WA_A = 4'd8; W_DA = 32'hBBBBBBBB;
        @(posedge CLK); #1;


        WEN_A = 1; WA_A = 4'd8; W_DA = 32'h44444444;
        @(posedge CLK); #1;
        WEN_A = 0;

        RA_A = 4'd8; RA_B = 4'd8; RA_C = 4'd8;
        #1;

        check_outputs(32'h44444444, 32'h44444444, 32'h44444444);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Address Boundary Check (Reg 15)", test_num);

        WEN_A = 1; WA_A = 4'hf; W_DA = 32'hF0F0F0F0;
        @(posedge CLK); #1;
        WEN_A = 0;

        RA_A = 4'hf; RA_B = 4'hf; RA_C = 4'hf;
        #1;

        check_outputs(32'hF0F0F0F0, 32'hF0F0F0F0, 32'hF0F0F0F0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Register 0 Check", test_num);

        WEN_A = 1; WA_A = 4'h0; W_DA = 32'h0C0C0C0C;
        @(posedge CLK); #1;
        WEN_A = 0;

        RA_A = 4'h0; RA_B = 4'h0; RA_C = 4'h0;
        #1;

        check_outputs(32'h0C0C0C0C, 32'h0C0C0C0C, 32'h0C0C0C0C);
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
        input [31:0] expected_GRF_X;
        input [31:0] expected_GRF_Y;
        input [31:0] expected_GRF_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GRF_X === (expected_GRF_X ^ GRF_X ^ expected_GRF_X) &&
                expected_GRF_Y === (expected_GRF_Y ^ GRF_Y ^ expected_GRF_Y) &&
                expected_GRF_Z === (expected_GRF_Z ^ GRF_Z ^ expected_GRF_Z)) begin
                $display("PASS");
                $display("  Outputs: GRF_X=%h, GRF_Y=%h, GRF_Z=%h",
                         GRF_X, GRF_Y, GRF_Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GRF_X=%h, GRF_Y=%h, GRF_Z=%h",
                         expected_GRF_X, expected_GRF_Y, expected_GRF_Z);
                $display("  Got:      GRF_X=%h, GRF_Y=%h, GRF_Z=%h",
                         GRF_X, GRF_Y, GRF_Z);
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
