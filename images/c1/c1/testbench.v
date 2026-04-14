`timescale 1ns/1ps

module IFID_Stage_tb;

    // Testbench signals (sequential circuit)
    reg ID_Stall;
    reg IF_Flush;
    reg [31:0] IF_Instruction;
    reg IF_IsBDS;
    reg [31:0] IF_PC;
    reg [31:0] IF_PCAdd4;
    reg IF_Stall;
    reg clock;
    reg reset;
    wire [31:0] ID_Instruction;
    wire ID_IsBDS;
    wire ID_IsFlushed;
    wire [31:0] ID_PCAdd4;
    wire [31:0] ID_RestartPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IFID_Stage dut (
        .ID_Stall(ID_Stall),
        .IF_Flush(IF_Flush),
        .IF_Instruction(IF_Instruction),
        .IF_IsBDS(IF_IsBDS),
        .IF_PC(IF_PC),
        .IF_PCAdd4(IF_PCAdd4),
        .IF_Stall(IF_Stall),
        .clock(clock),
        .reset(reset),
        .ID_Instruction(ID_Instruction),
        .ID_IsBDS(ID_IsBDS),
        .ID_IsFlushed(ID_IsFlushed),
        .ID_PCAdd4(ID_PCAdd4),
        .ID_RestartPC(ID_RestartPC)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ID_Stall = 0;
            IF_Flush = 0;
            IF_Instruction = 32'h0;
            IF_IsBDS = 0;
            IF_PC = 32'h0;
            IF_PCAdd4 = 32'h0;
            IF_Stall = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 0, 0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Normal Instruction Flow", test_num);
            reset_dut();

            IF_Instruction = 32'hAABBCCDD;
            IF_PC = 32'h00001000;
            IF_PCAdd4 = 32'h00001004;
            IF_IsBDS = 0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hAABBCCDD, 0, 0, 32'h00001004, 32'h00001000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: ID Stage Stall", test_num);
            reset_dut();


            IF_Instruction = 32'h11111111;
            IF_PC = 32'h100;
            IF_PCAdd4 = 32'h104;
            @(posedge clock);
            #1;


            ID_Stall = 1;
            IF_Instruction = 32'hEEEEEEEE;
            IF_PC = 32'h200;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h11111111, 0, 0, 32'h104, 32'h100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: IF Flush Logic", test_num);
            reset_dut();

            IF_Instruction = 32'h88888888;
            IF_Flush = 1;

            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h0, 0, 1, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: BDS Propagation", test_num);
            reset_dut();

            IF_Instruction = 32'hADD1ADD1;
            IF_IsBDS = 1;
            IF_PC = 32'h400;
            IF_PCAdd4 = 32'h404;

            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hADD1ADD1, 1, 0, 32'h404, 32'h400);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: IF Stall Handling", test_num);
            reset_dut();

            IF_Stall = 1;
            IF_Instruction = 32'hFFFFFFFF;

            @(posedge clock);
            #1;



            #1;




            check_outputs(32'h0, 0, 0, 32'h0, 32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: ID Stall Priority Over Flush", test_num);
            reset_dut();


            IF_Instruction = 32'h5555AAAA;
            @(posedge clock);
            #1;


            ID_Stall = 1;
            IF_Flush = 1;
            IF_Instruction = 32'h0;

            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h5555AAAA, 0, 0, 32'h0, 32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IFID_Stage Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_ID_Instruction;
        input expected_ID_IsBDS;
        input expected_ID_IsFlushed;
        input [31:0] expected_ID_PCAdd4;
        input [31:0] expected_ID_RestartPC;
        begin
            if (expected_ID_Instruction === (expected_ID_Instruction ^ ID_Instruction ^ expected_ID_Instruction) &&
                expected_ID_IsBDS === (expected_ID_IsBDS ^ ID_IsBDS ^ expected_ID_IsBDS) &&
                expected_ID_IsFlushed === (expected_ID_IsFlushed ^ ID_IsFlushed ^ expected_ID_IsFlushed) &&
                expected_ID_PCAdd4 === (expected_ID_PCAdd4 ^ ID_PCAdd4 ^ expected_ID_PCAdd4) &&
                expected_ID_RestartPC === (expected_ID_RestartPC ^ ID_RestartPC ^ expected_ID_RestartPC)) begin
                $display("PASS");
                $display("  Outputs: ID_Instruction=%h, ID_IsBDS=%b, ID_IsFlushed=%b, ID_PCAdd4=%h, ID_RestartPC=%h",
                         ID_Instruction, ID_IsBDS, ID_IsFlushed, ID_PCAdd4, ID_RestartPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID_Instruction=%h, ID_IsBDS=%b, ID_IsFlushed=%b, ID_PCAdd4=%h, ID_RestartPC=%h",
                         expected_ID_Instruction, expected_ID_IsBDS, expected_ID_IsFlushed, expected_ID_PCAdd4, expected_ID_RestartPC);
                $display("  Got:      ID_Instruction=%h, ID_IsBDS=%b, ID_IsFlushed=%b, ID_PCAdd4=%h, ID_RestartPC=%h",
                         ID_Instruction, ID_IsBDS, ID_IsFlushed, ID_PCAdd4, ID_RestartPC);
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
        $dumpvars(0,ID_Stall, IF_Flush, IF_Instruction, IF_IsBDS, IF_PC, IF_PCAdd4, IF_Stall, clock, reset, ID_Instruction, ID_IsBDS, ID_IsFlushed, ID_PCAdd4, ID_RestartPC);
    end

endmodule
