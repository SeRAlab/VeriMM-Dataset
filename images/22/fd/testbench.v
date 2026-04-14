`timescale 1ns/1ps

module nvme_command_register_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] cid_in;
    reg clk;
    reg [3:0] ct_in;
    reg load;
    reg reset;
    wire [15:0] cid_out;
    wire [3:0] ct_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_register dut (
        .cid_in(cid_in),
        .clk(clk),
        .ct_in(ct_in),
        .load(load),
        .reset(reset),
        .cid_out(cid_out),
        .ct_out(ct_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            cid_in = 16'h0;
            ct_in = 4'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Load Operation", test_num);
            reset_dut();

            cid_in = 16'hABCD;
            ct_in = 4'h5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(16'hABCD, 4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Hold Value (Load=0)", test_num);
            reset_dut();


            cid_in = 16'h1234;
            ct_in = 4'hA;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            cid_in = 16'hFFFF;
            ct_in = 4'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Reset Behavior mid-operation", test_num);
            reset_dut();


            cid_in = 16'h5555;
            ct_in = 4'h3;
            load = 1;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(16'h0000, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Consecutive Load Operations", test_num);
            reset_dut();


            cid_in = 16'hAAAA;
            ct_in = 4'h1;
            load = 1;
            @(posedge clk);
            #1;


            cid_in = 16'hBBBB;
            ct_in = 4'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hBBBB, 4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Maximum Values (All 1s)", test_num);
            reset_dut();

            cid_in = 16'hFFFF;
            ct_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(16'hFFFF, 4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_register Testbench");
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
        input [15:0] expected_cid_out;
        input [3:0] expected_ct_out;
        begin
            if (expected_cid_out === (expected_cid_out ^ cid_out ^ expected_cid_out) &&
                expected_ct_out === (expected_ct_out ^ ct_out ^ expected_ct_out)) begin
                $display("PASS");
                $display("  Outputs: cid_out=%h, ct_out=%h",
                         cid_out, ct_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cid_out=%h, ct_out=%h",
                         expected_cid_out, expected_ct_out);
                $display("  Got:      cid_out=%h, ct_out=%h",
                         cid_out, ct_out);
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
        $dumpvars(0,cid_in, clk, ct_in, load, reset, cid_out, ct_out);
    end

endmodule
