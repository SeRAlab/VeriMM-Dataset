`timescale 1ns/1ps

module pipeline_processor_tb;

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
    pipeline_processor dut (
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
            $display("Resetting DUT...");
            reset = 1;
            instruction = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction = 32'hABCD_1234;
            @(posedge clk);


            instruction = 32'h0;
            repeat(6) @(posedge clk);


            #1;
            #1;

            check_outputs(32'hABCD_1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Pipeline", test_num);
            reset_dut();


            instruction = 32'hFFFF_FFFF;
            @(posedge clk);
            instruction = 32'h0;
            repeat(3) @(posedge clk);


            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;


            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Back-to-back Instruction Stream", test_num);
            reset_dut();


            instruction = 32'h1111_1111; @(posedge clk);
            instruction = 32'h2222_2222; @(posedge clk);
            instruction = 32'h3333_3333; @(posedge clk);
            instruction = 32'h4444_4444; @(posedge clk);
            instruction = 32'h5555_5555; @(posedge clk);
            instruction = 32'h6666_6666; @(posedge clk);
            instruction = 32'h7777_7777; @(posedge clk);


            #1;
            #1;

            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Stream Latency (7th value)", test_num);
            reset_dut();


            instruction = 32'h0000_0001; @(posedge clk);
            instruction = 32'h0000_0002; @(posedge clk);
            instruction = 32'h0000_0003; @(posedge clk);
            instruction = 32'h0000_0004; @(posedge clk);
            instruction = 32'h0000_0005; @(posedge clk);
            instruction = 32'h0000_0006; @(posedge clk);
            instruction = 32'h0000_0007; @(posedge clk);


            repeat(6) @(posedge clk);

            #1;
            #1;

            check_outputs(32'h0000_0007);
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
