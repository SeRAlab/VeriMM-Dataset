`timescale 1ns/1ps

module pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] EX_MEM_instruction;
    wire [31:0] ID_EX_instruction;
    wire [31:0] IF_ID_instruction;
    wire [31:0] MEM_WB_instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .EX_MEM_instruction(EX_MEM_instruction),
        .ID_EX_instruction(ID_EX_instruction),
        .IF_ID_instruction(IF_ID_instruction),
        .MEM_WB_instruction(MEM_WB_instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Pipeline Stream", test_num);
            reset_dut();


            instruction_in = 32'hAAAA_AAAA;
            @(posedge clk); #1;


            instruction_in = 32'hBBBB_BBBB;
            @(posedge clk); #1;


            instruction_in = 32'hCCCC_CCCC;
            @(posedge clk); #1;


            instruction_in = 32'hDDDD_DDDD;
            @(posedge clk); #1;



            #1;




            check_outputs(32'hBBBB_BBBB, 32'hCCCC_CCCC, 32'hDDDD_DDDD, 32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 32'h1234_5678;
            @(posedge clk); #1;


            instruction_in = 32'h0;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;



            #1;




            check_outputs(32'h0, 32'h0, 32'h0, 32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline Reset Verification", test_num);
            reset_dut();


            instruction_in = 32'hFFFF_FFFF;
            @(posedge clk); #1;
            instruction_in = 32'hEEEE_EEEE;
            @(posedge clk); #1;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;


            #1;



            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Patterns", test_num);
            reset_dut();

            instruction_in = 32'h1111_1111; @(posedge clk); #1;
            instruction_in = 32'h2222_2222; @(posedge clk); #1;
            instruction_in = 32'h1111_1111; @(posedge clk); #1;
            instruction_in = 32'h2222_2222; @(posedge clk); #1;



            #1;




            check_outputs(32'h2222_2222, 32'h1111_1111, 32'h2222_2222, 32'h1111_1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline Testbench");
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
        input [31:0] expected_EX_MEM_instruction;
        input [31:0] expected_ID_EX_instruction;
        input [31:0] expected_IF_ID_instruction;
        input [31:0] expected_MEM_WB_instruction;
        begin
            if (expected_EX_MEM_instruction === (expected_EX_MEM_instruction ^ EX_MEM_instruction ^ expected_EX_MEM_instruction) &&
                expected_ID_EX_instruction === (expected_ID_EX_instruction ^ ID_EX_instruction ^ expected_ID_EX_instruction) &&
                expected_IF_ID_instruction === (expected_IF_ID_instruction ^ IF_ID_instruction ^ expected_IF_ID_instruction) &&
                expected_MEM_WB_instruction === (expected_MEM_WB_instruction ^ MEM_WB_instruction ^ expected_MEM_WB_instruction)) begin
                $display("PASS");
                $display("  Outputs: EX_MEM_instruction=%h, ID_EX_instruction=%h, IF_ID_instruction=%h, MEM_WB_instruction=%h",
                         EX_MEM_instruction, ID_EX_instruction, IF_ID_instruction, MEM_WB_instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX_MEM_instruction=%h, ID_EX_instruction=%h, IF_ID_instruction=%h, MEM_WB_instruction=%h",
                         expected_EX_MEM_instruction, expected_ID_EX_instruction, expected_IF_ID_instruction, expected_MEM_WB_instruction);
                $display("  Got:      EX_MEM_instruction=%h, ID_EX_instruction=%h, IF_ID_instruction=%h, MEM_WB_instruction=%h",
                         EX_MEM_instruction, ID_EX_instruction, IF_ID_instruction, MEM_WB_instruction);
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
        $dumpvars(0,clk, instruction_in, reset, EX_MEM_instruction, ID_EX_instruction, IF_ID_instruction, MEM_WB_instruction);
    end

endmodule
