`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg done;
    reg reset;
    reg start;
    wire [15:0] data_out;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .clk(clk),
        .data_in(data_in),
        .done(done),
        .reset(reset),
        .start(start),
        .data_out(data_out),
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
            start = 0;
            done = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: IDLE to TRANSMITTING to COMPLETE transition", test_num);
            reset_dut();


            start = 1;
            data_in = 16'hABCD;
            @(posedge clk);
            #1 start = 0;


            done = 1;
            @(posedge clk);
            #1 done = 0;



            #1;




            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Data latching and integrity check", test_num);
            reset_dut();

            start = 1;
            data_in = 16'h55AA;
            @(posedge clk);
            #1 start = 0;
            data_in = 16'hFFFF;

            done = 1;
            @(posedge clk);
            #1 done = 0;

            #1;


            check_outputs(16'h55AA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Full lifecycle and return to IDLE via reset", test_num);
            reset_dut();


            start = 1;
            data_in = 16'h1234;
            @(posedge clk);
            #1 start = 0;
            done = 1;
            @(posedge clk);
            #1 done = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Verify 'done' signal is ignored in IDLE state", test_num);
            reset_dut();

            done = 1;
            @(posedge clk);
            #1 done = 0;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Emergency reset during TRANSMITTING state", test_num);
            reset_dut();

            start = 1;
            data_in = 16'hBEEF;
            @(posedge clk);
            #1 start = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
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
        input [15:0] expected_data_out;
        input expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, state=%b",
                         data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, state=%b",
                         expected_data_out, expected_state);
                $display("  Got:      data_out=%h, state=%b",
                         data_out, state);
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
        $dumpvars(0,clk, data_in, done, reset, start, data_out, state);
    end

endmodule
