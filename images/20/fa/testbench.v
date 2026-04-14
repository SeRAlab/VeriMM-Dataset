`timescale 1ns/1ps

module aes_shiftrows_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [127:0] state_in;
    wire [127:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_shiftrows dut (
        .clk(clk),
        .reset(reset),
        .state_in(state_in),
        .state_out(state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            state_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: All Zeros");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Incremental Pattern");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h00010203_04050607_08090a0b_0c0d0e0f;
            @(posedge clk);
            #1 #1;
 check_outputs(128'h00050a0f_04090e03_080d0207_0c01060b);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: All 0xFF");
            reset_dut();
            test_num = test_num + 1;
            state_in = {16{8'hFF}};
            @(posedge clk);
            #1 #1;
 check_outputs({16{8'hFF}});
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: NIST Standard Vector");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'hd4bf5d30_e0b452ae_b84111f1_1e2798e5;
            @(posedge clk);
            #1 #1;
 check_outputs(128'hd4b411e5_e0419830_b8275dae_1ebf52f1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Alternating AA/55 Pattern");
            reset_dut();
            test_num = test_num + 1;

            state_in = 128'haa55aa55_aa55aa55_aa55aa55_aa55aa55;
            @(posedge clk);
            #1 #1;
 check_outputs(128'haa55aa55_aa55aa55_aa55aa55_aa55aa55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_shiftrows Testbench");
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
        input [127:0] expected_state_out;
        begin
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
        $dumpvars(0,clk, reset, state_in, state_out);
    end

endmodule
