`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] InsTagAllign;
    reg [3:0] Opcode_Allign;
    reg clock;
    reg [35:0] cout_Allign;
    reg idle_Allign;
    reg [31:0] sout_Allign;
    reg [31:0] z_postAllign;
    reg [35:0] zout_Allign;
    wire [7:0] InsTagAdder;
    wire [3:0] Opcode_AddState;
    wire idle_AddState;
    wire [31:0] sout_AddState;
    wire [27:0] sum_AddState;
    wire [31:0] z_postAddState;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InsTagAllign(InsTagAllign),
        .Opcode_Allign(Opcode_Allign),
        .clock(clock),
        .cout_Allign(cout_Allign),
        .idle_Allign(idle_Allign),
        .sout_Allign(sout_Allign),
        .z_postAllign(z_postAllign),
        .zout_Allign(zout_Allign),
        .InsTagAdder(InsTagAdder),
        .Opcode_AddState(Opcode_AddState),
        .idle_AddState(idle_AddState),
        .sout_AddState(sout_AddState),
        .sum_AddState(sum_AddState),
        .z_postAddState(z_postAddState)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        InsTagAllign = 8'h0;
        Opcode_Allign = 4'h0;
        cout_Allign = 36'h0;
        idle_Allign = 1'b1;
        sout_Allign = 32'h0;
        z_postAllign = 32'h0;
        zout_Allign = 36'h0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        InsTagAllign = 8'hA1;
        Opcode_Allign = 4'h0;
        idle_Allign = 1'b0;
        cout_Allign = 36'h000000A00;
        zout_Allign = 36'h000000500;
        sout_Allign = 32'h11112222;
        z_postAllign = 32'h33334444;

        @(posedge clock);
        #2;

        #1;


        check_outputs(8'hA1, 4'h0, 1'b0, 32'h11112222, 28'h000000F, 32'h33334444);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        InsTagAllign = 8'hB2;
        Opcode_Allign = 4'h1;
        idle_Allign = 1'b0;
        cout_Allign = 36'h000001400;
        zout_Allign = 36'h000000600;
        sout_Allign = 32'hAAAA_BBBB;
        z_postAllign = 32'hCCCC_DDDD;

        @(posedge clock);
        #2;

        #1;


        check_outputs(8'hB2, 4'h1, 1'b0, 32'hAAAA_BBBB, 28'h000000E, 32'hCCCC_DDDD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        idle_Allign = 1'b1;
        InsTagAllign = 8'hFF;

        @(posedge clock);
        #2;

        #1;


        check_outputs(8'hFF, 4'h0, 1'b1, 32'h0, 28'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        InsTagAllign = 8'h44;
        Opcode_Allign = 4'h0;
        idle_Allign = 1'b0;
        cout_Allign = 36'h0FFFFF000;
        zout_Allign = 36'h000001000;

        @(posedge clock);
        #2;

        #1;


        check_outputs(8'h44, 4'h0, 1'b0, 32'h0, 28'h0100000, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        InsTagAllign = 8'h55;
        sout_Allign = 32'hDEADBEEF;
        z_postAllign = 32'hCAFEBABE;
        idle_Allign = 1'b0;

        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h55, 4'h0, 1'b0, 32'hDEADBEEF, 28'h0, 32'hCAFEBABE);
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
        input [7:0] expected_InsTagAdder;
        input [3:0] expected_Opcode_AddState;
        input expected_idle_AddState;
        input [31:0] expected_sout_AddState;
        input [27:0] expected_sum_AddState;
        input [31:0] expected_z_postAddState;
        begin
            if (expected_InsTagAdder === (expected_InsTagAdder ^ InsTagAdder ^ expected_InsTagAdder) &&
                expected_Opcode_AddState === (expected_Opcode_AddState ^ Opcode_AddState ^ expected_Opcode_AddState) &&
                expected_idle_AddState === (expected_idle_AddState ^ idle_AddState ^ expected_idle_AddState) &&
                expected_sout_AddState === (expected_sout_AddState ^ sout_AddState ^ expected_sout_AddState) &&
                expected_sum_AddState === (expected_sum_AddState ^ sum_AddState ^ expected_sum_AddState) &&
                expected_z_postAddState === (expected_z_postAddState ^ z_postAddState ^ expected_z_postAddState)) begin
                $display("PASS");
                $display("  Outputs: InsTagAdder=%h, Opcode_AddState=%h, idle_AddState=%b, sout_AddState=%h, sum_AddState=%h, z_postAddState=%h",
                         InsTagAdder, Opcode_AddState, idle_AddState, sout_AddState, sum_AddState, z_postAddState);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: InsTagAdder=%h, Opcode_AddState=%h, idle_AddState=%b, sout_AddState=%h, sum_AddState=%h, z_postAddState=%h",
                         expected_InsTagAdder, expected_Opcode_AddState, expected_idle_AddState, expected_sout_AddState, expected_sum_AddState, expected_z_postAddState);
                $display("  Got:      InsTagAdder=%h, Opcode_AddState=%h, idle_AddState=%b, sout_AddState=%h, sum_AddState=%h, z_postAddState=%h",
                         InsTagAdder, Opcode_AddState, idle_AddState, sout_AddState, sum_AddState, z_postAddState);
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
        $dumpvars(0,InsTagAllign, Opcode_Allign, clock, cout_Allign, idle_Allign, sout_Allign, z_postAllign, zout_Allign, InsTagAdder, Opcode_AddState, idle_AddState, sout_AddState, sum_AddState, z_postAddState);
    end

endmodule
