`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ID_Instruction;
    reg ID_IsBDS;
    reg ID_IsFlushed;
    reg [31:0] ID_PCAdd4;
    reg [31:0] ID_RestartPC;
    reg ID_Stall;
    reg IF_Flush;
    reg [31:0] IF_Instruction;
    reg IF_IsBDS;
    reg [31:0] IF_PC;
    reg [31:0] IF_PCAdd4;
    reg IF_Stall;
    reg clock;
    reg reset;
    wire [31:0] vote_ID_Instruction;
    wire vote_ID_IsBDS;
    wire vote_ID_IsFlushed;
    wire [31:0] vote_ID_PCAdd4;
    wire [31:0] vote_ID_RestartPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ID_Instruction(ID_Instruction),
        .ID_IsBDS(ID_IsBDS),
        .ID_IsFlushed(ID_IsFlushed),
        .ID_PCAdd4(ID_PCAdd4),
        .ID_RestartPC(ID_RestartPC),
        .ID_Stall(ID_Stall),
        .IF_Flush(IF_Flush),
        .IF_Instruction(IF_Instruction),
        .IF_IsBDS(IF_IsBDS),
        .IF_PC(IF_PC),
        .IF_PCAdd4(IF_PCAdd4),
        .IF_Stall(IF_Stall),
        .clock(clock),
        .reset(reset),
        .vote_ID_Instruction(vote_ID_Instruction),
        .vote_ID_IsBDS(vote_ID_IsBDS),
        .vote_ID_IsFlushed(vote_ID_IsFlushed),
        .vote_ID_PCAdd4(vote_ID_PCAdd4),
        .vote_ID_RestartPC(vote_ID_RestartPC)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ID_Instruction = 0;
            ID_IsBDS = 0;
            ID_IsFlushed = 0;
            ID_PCAdd4 = 0;
            ID_RestartPC = 0;
            ID_Stall = 0;
            IF_Flush = 0;
            IF_Instruction = 0;
            IF_IsBDS = 0;
            IF_PC = 0;
            IF_PCAdd4 = 0;
            IF_Stall = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0, 1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Normal Data Capture");
            reset_dut();

            ID_Instruction = 32'hAABBCCDD;
            ID_PCAdd4 = 32'h00001004;
            ID_RestartPC = 32'h00001000;
            ID_IsBDS = 1'b1;
            ID_IsFlushed = 1'b0;
            ID_Stall = 1'b0;
            IF_Flush = 1'b0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hAABBCCDD, 1'b1, 1'b0, 32'h00001004, 32'h00001000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: ID_Stall Handling");
            reset_dut();


            ID_Instruction = 32'h11112222;
            ID_Stall = 1'b0;
            @(posedge clock);
            #1;


            ID_Stall = 1'b1;
            ID_Instruction = 32'hFFFFFFFF;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h11112222, 1'b0, 1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: IF_Flush Handling");
            reset_dut();


            ID_Instruction = 32'h55556666;
            ID_Stall = 1'b0;
            IF_Flush = 1'b0;
            @(posedge clock);
            #1;


            IF_Flush = 1'b1;
            ID_Instruction = 32'h77778888;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h0, 1'b0, 1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Status Flags Propagation");
            reset_dut();

            ID_Instruction = 32'h12345678;
            ID_IsBDS = 1'b1;
            ID_IsFlushed = 1'b1;
            ID_Stall = 1'b0;
            IF_Flush = 1'b0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b1, 1'b1, 32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Flush vs Stall Priority");
            reset_dut();


            ID_Instruction = 32'hDEADBEEF;
            ID_Stall = 1'b0;
            @(posedge clock);
            #1;


            ID_Stall = 1'b1;
            IF_Flush = 1'b1;
            ID_Instruction = 32'hCAFEBABE;
            @(posedge clock);
            #1;




            #1;





            check_outputs(32'h0, 1'b0, 1'b0, 32'h0, 32'h0);
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
        input [31:0] expected_vote_ID_Instruction;
        input expected_vote_ID_IsBDS;
        input expected_vote_ID_IsFlushed;
        input [31:0] expected_vote_ID_PCAdd4;
        input [31:0] expected_vote_ID_RestartPC;
        begin
            if (expected_vote_ID_Instruction === (expected_vote_ID_Instruction ^ vote_ID_Instruction ^ expected_vote_ID_Instruction) &&
                expected_vote_ID_IsBDS === (expected_vote_ID_IsBDS ^ vote_ID_IsBDS ^ expected_vote_ID_IsBDS) &&
                expected_vote_ID_IsFlushed === (expected_vote_ID_IsFlushed ^ vote_ID_IsFlushed ^ expected_vote_ID_IsFlushed) &&
                expected_vote_ID_PCAdd4 === (expected_vote_ID_PCAdd4 ^ vote_ID_PCAdd4 ^ expected_vote_ID_PCAdd4) &&
                expected_vote_ID_RestartPC === (expected_vote_ID_RestartPC ^ vote_ID_RestartPC ^ expected_vote_ID_RestartPC)) begin
                $display("PASS");
                $display("  Outputs: vote_ID_Instruction=%h, vote_ID_IsBDS=%b, vote_ID_IsFlushed=%b, vote_ID_PCAdd4=%h, vote_ID_RestartPC=%h",
                         vote_ID_Instruction, vote_ID_IsBDS, vote_ID_IsFlushed, vote_ID_PCAdd4, vote_ID_RestartPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vote_ID_Instruction=%h, vote_ID_IsBDS=%b, vote_ID_IsFlushed=%b, vote_ID_PCAdd4=%h, vote_ID_RestartPC=%h",
                         expected_vote_ID_Instruction, expected_vote_ID_IsBDS, expected_vote_ID_IsFlushed, expected_vote_ID_PCAdd4, expected_vote_ID_RestartPC);
                $display("  Got:      vote_ID_Instruction=%h, vote_ID_IsBDS=%b, vote_ID_IsFlushed=%b, vote_ID_PCAdd4=%h, vote_ID_RestartPC=%h",
                         vote_ID_Instruction, vote_ID_IsBDS, vote_ID_IsFlushed, vote_ID_PCAdd4, vote_ID_RestartPC);
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
        $dumpvars(0,ID_Instruction, ID_IsBDS, ID_IsFlushed, ID_PCAdd4, ID_RestartPC, ID_Stall, IF_Flush, IF_Instruction, IF_IsBDS, IF_PC, IF_PCAdd4, IF_Stall, clock, reset, vote_ID_Instruction, vote_ID_IsBDS, vote_ID_IsFlushed, vote_ID_PCAdd4, vote_ID_RestartPC);
    end

endmodule
