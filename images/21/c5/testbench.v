`timescale 1ns/1ps

module state_machine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [2:0] state_input;
    wire [1:0] state_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_machine dut (
        .clk(clk),
        .reset(reset),
        .state_input(state_input),
        .state_output(state_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        state_input = 3'b000;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying initial state after reset", test_num);
        reset_dut();
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input 3'b001 (1 increment)", test_num);
        reset_dut();
        state_input = 3'b001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input 3'b101 (2 increments)", test_num);
        reset_dut();
        state_input = 3'b101;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input 3'b111 (3 increments)", test_num);
        reset_dut();
        state_input = 3'b111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Accumulate 3 then 1 (Wraparound to 0)", test_num);
        reset_dut();
        state_input = 3'b111;
        @(posedge clk);
        #1;
        state_input = 3'b010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Accumulate 2 then 3 (Wraparound to 1)", test_num);
        reset_dut();
        state_input = 3'b110;
        @(posedge clk);
        #1;
        state_input = 3'b111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input 3'b000 (No change)", test_num);
        reset_dut();
        state_input = 3'b001;
        @(posedge clk);
        #1;
        state_input = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Complex sequence 1->2->3->0 increments", test_num);
        reset_dut();
        state_input = 3'b001;
        @(posedge clk);
        #1;
        state_input = 3'b011;
        @(posedge clk);
        #1;
        state_input = 3'b111;
        @(posedge clk);
        #1;
        state_input = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_machine Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_state_output;
        begin
            if (expected_state_output === (expected_state_output ^ state_output ^ expected_state_output)) begin
                $display("PASS");
                $display("  Outputs: state_output=%h",
                         state_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_output=%h",
                         expected_state_output);
                $display("  Got:      state_output=%h",
                         state_output);
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
        $dumpvars(0,clk, reset, state_input, state_output);
    end

endmodule
