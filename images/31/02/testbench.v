`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg rst;
    reg [4:0] write_register;
    wire [31:0] EX_stage;
    wire [31:0] FW_stage;
    wire [31:0] HD_stage;
    wire [31:0] ID_stage;
    wire [31:0] IF_stage;
    wire [31:0] MEM_stage;
    wire [31:0] WB_stage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction(instruction),
        .rst(rst),
        .write_register(write_register),
        .EX_stage(EX_stage),
        .FW_stage(FW_stage),
        .HD_stage(HD_stage),
        .ID_stage(ID_stage),
        .IF_stage(IF_stage),
        .MEM_stage(MEM_stage),
        .WB_stage(WB_stage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction = 32'h0;
            write_register = 5'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction = 32'hDEADBEEF;
            @(posedge clk);


            instruction = 32'h0;
            repeat (6) @(posedge clk);



            #1 #1;
 check_outputs(
                32'h00000000,
                32'h00000000,
                32'hDEADBEEF,
                32'h00000000,
                32'h00000000,
                32'h00000000,
                32'h00000000
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full Pipeline Fill", test_num);
            reset_dut();


            instruction = 32'h11111111; @(posedge clk);
            instruction = 32'h22222222; @(posedge clk);
            instruction = 32'h33333333; @(posedge clk);
            instruction = 32'h44444444; @(posedge clk);
            instruction = 32'h55555555; @(posedge clk);
            instruction = 32'h66666666; @(posedge clk);
            instruction = 32'h77777777; @(posedge clk);


            #1 #1;
 check_outputs(
                32'h55555555,
                32'h22222222,
                32'h11111111,
                32'h66666666,
                32'h77777777,
                32'h44444444,
                32'h33333333
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Partial Pipeline Fill", test_num);
            reset_dut();

            instruction = 32'hAAAA_AAAA; @(posedge clk);
            instruction = 32'hBBBB_BBBB; @(posedge clk);
            instruction = 32'hCCCC_CCCC; @(posedge clk);

            #1 #1;
 check_outputs(
                32'hAAAA_AAAA,
                32'h0000_0000,
                32'h0000_0000,
                32'hBBBB_BBBB,
                32'hCCCC_CCCC,
                32'h0000_0000,
                32'h0000_0000
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Propagation with WB Register", test_num);
            reset_dut();

            write_register = 5'd15;
            instruction = 32'hF0F0_F0F0;
            @(posedge clk);

            instruction = 32'h0;
            repeat (4) @(posedge clk);


            #1 #1;
 check_outputs(
                32'h0000_0000,
                32'h0000_0000,
                32'h0000_0000,
                32'h0000_0000,
                32'h0000_0000,
                32'h0000_0000,
                32'hF0F0_F0F0
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Mid-Operation", test_num);
            reset_dut();


            instruction = 32'h1234_5678; @(posedge clk);
            instruction = 32'h8765_4321; @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1 #1;
 check_outputs(
                32'h0,
                32'h0,
                32'h0,
                32'h0,
                32'h0,
                32'h0,
                32'h0
            );
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [31:0] expected_EX_stage;
        input [31:0] expected_FW_stage;
        input [31:0] expected_HD_stage;
        input [31:0] expected_ID_stage;
        input [31:0] expected_IF_stage;
        input [31:0] expected_MEM_stage;
        input [31:0] expected_WB_stage;
        begin
            if (expected_EX_stage === (expected_EX_stage ^ EX_stage ^ expected_EX_stage) &&
                expected_FW_stage === (expected_FW_stage ^ FW_stage ^ expected_FW_stage) &&
                expected_HD_stage === (expected_HD_stage ^ HD_stage ^ expected_HD_stage) &&
                expected_ID_stage === (expected_ID_stage ^ ID_stage ^ expected_ID_stage) &&
                expected_IF_stage === (expected_IF_stage ^ IF_stage ^ expected_IF_stage) &&
                expected_MEM_stage === (expected_MEM_stage ^ MEM_stage ^ expected_MEM_stage) &&
                expected_WB_stage === (expected_WB_stage ^ WB_stage ^ expected_WB_stage)) begin
                $display("PASS");
                $display("  Outputs: EX_stage=%h, FW_stage=%h, HD_stage=%h, ID_stage=%h, IF_stage=%h, MEM_stage=%h, WB_stage=%h",
                         EX_stage, FW_stage, HD_stage, ID_stage, IF_stage, MEM_stage, WB_stage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX_stage=%h, FW_stage=%h, HD_stage=%h, ID_stage=%h, IF_stage=%h, MEM_stage=%h, WB_stage=%h",
                         expected_EX_stage, expected_FW_stage, expected_HD_stage, expected_ID_stage, expected_IF_stage, expected_MEM_stage, expected_WB_stage);
                $display("  Got:      EX_stage=%h, FW_stage=%h, HD_stage=%h, ID_stage=%h, IF_stage=%h, MEM_stage=%h, WB_stage=%h",
                         EX_stage, FW_stage, HD_stage, ID_stage, IF_stage, MEM_stage, WB_stage);
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
        $dumpvars(0,clk, instruction, rst, write_register, EX_stage, FW_stage, HD_stage, ID_stage, IF_stage, MEM_stage, WB_stage);
    end

endmodule
