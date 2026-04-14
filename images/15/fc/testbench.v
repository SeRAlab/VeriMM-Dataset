`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] received;
    reg reset;
    wire estimated_data;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received(received),
        .reset(reset),
        .estimated_data(estimated_data),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        received = 2'b00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Power-on Reset check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Single step transition S0->S1", test_num);
        reset_dut();
        received = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Multi-step path S0->S1->S2", test_num);
        reset_dut();

        received = 2'b11;
        @(posedge clk);

        #1 received = 2'b10;
        @(posedge clk);

        #1;
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Path return S2 back to S1", test_num);
        reset_dut();

        received = 2'b11; @(posedge clk);
        received = 2'b10; @(posedge clk);
        received = 2'b11; @(posedge clk);

        #1;
        #1;

        check_outputs(1'b0, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Self-loop check (remain in S0)", test_num);
        reset_dut();

        received = 2'b00; @(posedge clk);
        received = 2'b00; @(posedge clk);
        received = 2'b00; @(posedge clk);

        #1;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
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
        input expected_estimated_data;
        input [1:0] expected_state;
        begin
            if (expected_estimated_data === (expected_estimated_data ^ estimated_data ^ expected_estimated_data) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: estimated_data=%b, state=%h",
                         estimated_data, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_data=%b, state=%h",
                         expected_estimated_data, expected_state);
                $display("  Got:      estimated_data=%b, state=%h",
                         estimated_data, state);
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
        $dumpvars(0,clk, received, reset, estimated_data, state);
    end

endmodule
