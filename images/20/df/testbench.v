`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] new_instruction;
    reg rst;
    wire [31:0] instruction_EX;
    wire [31:0] instruction_ID;
    wire [31:0] instruction_IF;
    wire [31:0] instruction_WB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .new_instruction(new_instruction),
        .rst(rst),
        .instruction_EX(instruction_EX),
        .instruction_ID(instruction_ID),
        .instruction_IF(instruction_IF),
        .instruction_WB(instruction_WB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            new_instruction = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Fill Pipeline", test_num);
            reset_dut();


            new_instruction = 32'hAAAA_AAAA;
            @(posedge clk); #1;


            new_instruction = 32'hBBBB_BBBB;
            @(posedge clk); #1;


            new_instruction = 32'hCCCC_CCCC;
            @(posedge clk); #1;


            new_instruction = 32'hDDDD_DDDD;
            @(posedge clk); #1;






            #1;







            check_outputs(32'hBBBB_BBBB, 32'hCCCC_CCCC, 32'hDDDD_DDDD, 32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Instruction Propagation", test_num);
            reset_dut();


            new_instruction = 32'h1234_5678;
            @(posedge clk); #1;
            new_instruction = 32'h0;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pipeline Reset Mid-Operation", test_num);
            reset_dut();


            new_instruction = 32'hFFFF_FFFF;
            @(posedge clk); #1;
            new_instruction = 32'hEEEE_EEEE;
            @(posedge clk); #1;


            rst = 1;
            @(posedge clk); #1;
            rst = 0;


            #1;



            check_outputs(32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pipeline Bubble Test", test_num);
            reset_dut();

            new_instruction = 32'h1111_1111;
            @(posedge clk); #1;
            new_instruction = 32'h0000_0000;
            @(posedge clk); #1;
            new_instruction = 32'h2222_2222;
            @(posedge clk); #1;
            new_instruction = 32'h3333_3333;
            @(posedge clk); #1;






            #1;







            check_outputs(32'h0000_0000, 32'h2222_2222, 32'h3333_3333, 32'h1111_1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Continuous Flow", test_num);
            reset_dut();

            new_instruction = 32'h0000_0001; @(posedge clk); #1;
            new_instruction = 32'h0000_0002; @(posedge clk); #1;
            new_instruction = 32'h0000_0003; @(posedge clk); #1;
            new_instruction = 32'h0000_0004; @(posedge clk); #1;
            new_instruction = 32'h0000_0005; @(posedge clk); #1;







            #1;








            check_outputs(32'h0000_0003, 32'h0000_0004, 32'h0000_0005, 32'h0000_0002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("instruction_pipeline Testbench");
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
        input [31:0] expected_instruction_EX;
        input [31:0] expected_instruction_ID;
        input [31:0] expected_instruction_IF;
        input [31:0] expected_instruction_WB;
        begin
            if (expected_instruction_EX === (expected_instruction_EX ^ instruction_EX ^ expected_instruction_EX) &&
                expected_instruction_ID === (expected_instruction_ID ^ instruction_ID ^ expected_instruction_ID) &&
                expected_instruction_IF === (expected_instruction_IF ^ instruction_IF ^ expected_instruction_IF) &&
                expected_instruction_WB === (expected_instruction_WB ^ instruction_WB ^ expected_instruction_WB)) begin
                $display("PASS");
                $display("  Outputs: instruction_EX=%h, instruction_ID=%h, instruction_IF=%h, instruction_WB=%h",
                         instruction_EX, instruction_ID, instruction_IF, instruction_WB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_EX=%h, instruction_ID=%h, instruction_IF=%h, instruction_WB=%h",
                         expected_instruction_EX, expected_instruction_ID, expected_instruction_IF, expected_instruction_WB);
                $display("  Got:      instruction_EX=%h, instruction_ID=%h, instruction_IF=%h, instruction_WB=%h",
                         instruction_EX, instruction_ID, instruction_IF, instruction_WB);
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
        $dumpvars(0,clk, new_instruction, rst, instruction_EX, instruction_ID, instruction_IF, instruction_WB);
    end

endmodule
