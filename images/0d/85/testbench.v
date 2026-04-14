`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg reset;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        instruction = 32'h0;
        @(posedge clk);
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Single Instruction Propagation", test_num);
        reset_dut();


        instruction = 32'hAAAA_5555;
        @(posedge clk);


        instruction = 32'h0;


        repeat (4) @(posedge clk);


        #2;
        #1;

        check_outputs(32'hAAAA_5555);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Pipeline Throughput (Back-to-back)", test_num);
        reset_dut();


        instruction = 32'h1111_1111; @(posedge clk);
        instruction = 32'h2222_2222; @(posedge clk);
        instruction = 32'h3333_3333; @(posedge clk);
        instruction = 32'h4444_4444; @(posedge clk);
        instruction = 32'h5555_5555; @(posedge clk);

        instruction = 32'h0;



        repeat (4) @(posedge clk);

        #2;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset During Operation", test_num);
        reset_dut();


        instruction = 32'hFFFF_FFFF; @(posedge clk);
        instruction = 32'hEEEE_EEEE; @(posedge clk);


        #2 reset = 1;
        @(posedge clk);
        reset = 0;


        repeat (5) @(posedge clk);

        #2;

        #1;


        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: NOP Instruction Handling", test_num);
        reset_dut();

        instruction = 32'h0000_0000;
        repeat (5) @(posedge clk);

        #2;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Final Pipeline Flush Check", test_num);
        reset_dut();


        instruction = 32'h1010_1010; @(posedge clk);
        instruction = 32'h2020_2020; @(posedge clk);
        instruction = 32'h3030_3030; @(posedge clk);
        instruction = 32'h4040_4040; @(posedge clk);
        instruction = 32'h5050_5050; @(posedge clk);


        instruction = 32'h0;
        repeat (10) @(posedge clk);

        #2;

        #1;


        check_outputs(32'h0000_0000);
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, instruction, reset, result);
    end

endmodule
